class Organization < ApplicationRecord
  phony_normalize :forwarding_phone_number, default_country_code: 'US'
  has_many :accounts, inverse_of: :organization
  has_many :owners, -> { owner }, class_name: 'Account'

  has_many :tags
  has_many :teams
  has_many :contacts
  has_many :inboxes, through: :teams
  has_many :conversations, through: :contacts
  has_many :payment_cards
  has_many :phone_numbers
  has_many :assignment_rules
  has_many :bots
  has_many :campaigns
  has_many :contact_stages, -> { ranked }

  has_many :locations, through: :teams
  has_many :recruiting_ads, through: :teams
  has_one :subscription

  belongs_to :recruiter, class_name: 'Account'
  has_one :recruiting_ad

  accepts_nested_attributes_for :teams, reject_if: :all_blank
  accepts_nested_attributes_for :contact_stages, reject_if: :all_blank,
                                                 allow_destroy: true

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: ''
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}
  delegate :person, to: :recruiter, prefix: true
  delegate :canceled?, :canceled_at, to: :subscription

  def screened_contacts_count
    contacts.screened.count
  end

  def recent_bot
    bots.recent.first
  end

  def recent_campaign
    campaigns.recent.first
  end

  def message(conversation:, body:, sender:, campaign: nil)
    contact = conversation.contact
    phone_number = conversation.phone_number
    sent_message = messaging_client.send_message(
      to: contact.phone_number, from: phone_number.phone_number, body: body
    )
    contact.update(reached: true) if sender.bot.blank?
    conversation.create_message(
      sent_message, sender, campaign
    ).tap { |message| Broadcaster::Message.broadcast(message) }
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
    stripe_customer_id.blank?
  end

  def payment_card
    payment_cards.first
  end

  def next_contact_stage_rank
    return 1 if contact_stages.last.blank?

    contact_stages.last.rank + 1
  end

  private

  def recruiter_notice
    "This is #{recruiter.first_name} with #{name}."
  end

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
