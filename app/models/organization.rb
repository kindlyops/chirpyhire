class Organization < ApplicationRecord
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

  has_many :locations, through: :teams
  has_many :recruiting_ads, through: :teams

  belongs_to :recruiter, class_name: 'Account'
  has_one :recruiting_ad

  accepts_nested_attributes_for :teams, reject_if: :all_blank

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: ''
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}
  delegate :person, to: :recruiter, prefix: true

  def message(contact:, body:, sender: nil, from:)
    sent_message = messaging_client.send_message(
      to: contact.phone_number, from: from, body: body
    )
    contact.update(reached: true) if sender != Chirpy.person

    contact.create_message(sent_message, sender).tap do |message|
      Broadcaster::Message.broadcast(message)
    end
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

  private

  def recruiter_notice
    "This is #{recruiter.first_name} with #{name}."
  end

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
