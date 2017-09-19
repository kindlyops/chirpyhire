class Organization < ApplicationRecord
  phony_normalize :forwarding_phone_number, default_country_code: 'US'
  has_many :accounts, inverse_of: :organization
  has_many :owners, -> { owner }, class_name: 'Account'

  has_many :tags
  has_many :teams
  has_many :contacts
  has_many :inboxes, through: :teams
  has_many :imports, through: :accounts
  has_many :invoices, primary_key: :stripe_id, foreign_key: :customer
  has_many :conversations, through: :contacts
  has_many :payment_cards
  has_many :phone_numbers
  has_many :assignment_rules
  has_many :bots
  has_many :campaigns
  has_many :messages
  has_many :contact_stages, -> { ranked }

  has_many :locations, through: :teams
  has_many :recruiting_ads, through: :teams
  has_one :subscription

  belongs_to :recruiter, class_name: 'Account'
  has_one :recruiting_ad

  accepts_nested_attributes_for :teams, reject_if: :all_blank
  accepts_nested_attributes_for :contact_stages, reject_if: :all_blank

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: ''
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}
  delegate :person, to: :recruiter, prefix: true
  delegate :canceled?, :internal_canceled_at, to: :subscription
  delegate :status, to: :subscription, prefix: true, allow_nil: true

  def silenced_invoices?
    !invoice_notification?
  end

  def recent_bot
    bots.recent.first
  end

  def recent_campaign
    campaigns.recent.first
  end

  def message(recipient:, phone_number:, body:, sender: nil)
    sent_message = messaging_client.send_message(
      to: recipient.phone_number, from: phone_number.phone_number, body: body
    )
    create_message(sent_message, sender, recipient)
  end

  def get_message(sid)
    messaging_client.messages.get(sid)
  end

  def subaccount?
    twilio_account_sid.present?
  end

  def sender_notice
    return recruiter_notice if recruiter && recruiter.first_name
    "This is #{name}."
  end

  def trialing?
    stripe_id.blank?
  end

  def payment_card
    payment_cards.order(:id).last
  end

  def next_contact_stage_rank
    return 1 if contact_stages.where.not(id: nil).last.blank?

    contact_stages.where.not(id: nil).last.rank + 1
  end

  private

  def create_message(message, sender, recipient)
    messages.create(message_params(message, sender, recipient))
  end

  def message_params(message, sender, recipient)
    base_message_params(message).merge(
      sent_at: message.date_sent,
      external_created_at: message.date_created,
      sender: sender,
      recipient: recipient
    )
  end

  def base_message_params(message)
    %i[sid body direction to from].each_with_object({}) do |key, hash|
      hash[key] = message.send(key)
    end
  end

  def recruiter_notice
    "This is #{recruiter.first_name} with #{name}."
  end

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
