class Organization < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_many :accounts, inverse_of: :organization
  has_many :conversations, through: :accounts

  has_many :teams
  has_many :contacts, through: :teams
  has_many :locations, through: :teams
  has_many :recruiting_ads, through: :teams

  has_many :suggestions, class_name: 'IdealCandidateSuggestion'
  has_many :messages

  belongs_to :recruiter, class_name: 'Account'
  has_one :ideal_candidate
  has_one :recruiting_ad
  has_one :location

  accepts_nested_attributes_for :teams, reject_if: :all_blank

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: ''
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}

  delegate :zipcode, to: :location
  delegate :person, to: :recruiter, prefix: true

  def message(contact:, body:, sender: nil)
    sent_message = messaging_client.send_message(
      to: contact.phone_number, from: contact.team_phone_number, body: body
    )

    create_message(contact.person, sent_message, sender).tap do |message|
      Broadcaster::Message.new(message).broadcast
    end
  end

  def get_message(sid)
    messaging_client.messages.get(sid)
  end

  def subaccount?
    twilio_account_sid.present?
  end

  private

  def create_message(recipient, message, sender)
    messages.create(
      sid: message.sid,
      body: message.body,
      sent_at: message.date_sent,
      external_created_at: message.date_created,
      direction: message.direction,
      sender: sender,
      recipient: recipient
    )
  end

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
