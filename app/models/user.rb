class User < ActiveRecord::Base
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
    organization.send_message(to: phone_number, body: body)
  end

  def receive_chirp(body:)
    message = receive_message(body: body)
    chirps.create(message_attributes: { sid: message.sid, body: message.body, direction: message.direction })
  end
end
