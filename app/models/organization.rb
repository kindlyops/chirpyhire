class Organization < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_many :accounts, inverse_of: :organization
  has_many :conversations, through: :accounts

  has_many :contacts
  has_many :people, through: :contacts, class_name: 'Person'
  belongs_to :recruiter, class_name: 'Account'
  has_one :ideal_candidate
  has_one :recruiting_ad
  has_one :location
  validates_associated :location
  validates :location, presence: true
  accepts_nested_attributes_for :location, reject_if: ->(l) { l.values.any?(&:blank?) }

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: ''
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}

  has_many :suggestions, class_name: 'IdealCandidateSuggestion'
  has_many :messages

  delegate :zipcode, :city, to: :location
  delegate :person, to: :recruiter, prefix: true

  def candidates
    people.joins(:candidacy)
  end

  def message(recipient:, body:, sender: nil)
    sent_message = messaging_client.send_message(
      to: recipient.phone_number, from: phone_number, body: body
    )

    create_message(recipient, sent_message, sender).tap do |message|
      Broadcaster::Message.new(message).broadcast
    end
  end

  def get_message(sid)
    messaging_client.messages.get(sid)
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
