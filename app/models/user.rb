class User < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  belongs_to :organization

  has_one :candidate
  has_one :referrer
  has_one :account
  has_many :activities, as: :owner
  has_many :messages
  has_many :inquiries, through: :messages
  has_many :answers, through: :messages
  has_many :notifications, through: :messages
  has_many :chirps, through: :messages

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
    message.save
    message
  end
end
