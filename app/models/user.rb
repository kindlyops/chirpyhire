class User < ActiveRecord::Base
  phony_normalize :phone_number, default_country_code: 'US'
  belongs_to :organization

  has_one :candidate
  has_one :referrer
  has_one :account
  has_many :messages
  has_many :inquiries, through: :messages
  has_many :answers, through: :messages
  has_many :notifications, through: :messages

  delegate :name, :phone_number, to: :organization, prefix: true
  delegate :contact_first_name, to: :organization
  accepts_nested_attributes_for :organization

  scope :with_phone_number, -> { where.not(phone_number: nil) }

  def outstanding_inquiry
    inquiries.unanswered.first
  end

  def answer(inquiry, sid)
    message = messages.create(sid: sid)
    inquiry.create_answer(message: message)
  end

  def receive_message(body:)
    message = organization.send_message(to: phone_number, body: body)
    messages.create(sid: message.sid)
  end
end
