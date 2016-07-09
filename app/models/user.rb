class User < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  belongs_to :organization

  has_one :candidate
  has_one :referrer
  has_one :account
  has_many :inquiries
  has_many :answers
  has_many :notifications
  has_many :chirps
  has_many :activities, as: :owner
  has_many :messages

  delegate :name, :phone_number, :candidate_persona, to: :organization, prefix: true
  delegate :contact_first_name, to: :organization
  accepts_nested_attributes_for :organization

  scope :with_phone_number, -> { where.not(phone_number: nil) }

  def outstanding_activities
    activities.outstanding
  end

  def outstanding_inquiry
    inquiries.unanswered.first
  end

  def receive_message(body:)
    message = organization.send_message(to: phone_number, body: body)
    message.user = self
    message
  end

  def receive_chirp(body:)
    message = receive_message(body: body)
    chirp = chirps.create(message: message)
    chirp.update(message_id: message.id)
    chirp
  end
end
