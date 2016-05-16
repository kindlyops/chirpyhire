class User < ActiveRecord::Base
  phony_normalize :phone_number, default_country_code: 'US'
  has_one :candidate
  has_one :referrer
  has_one :account
  belongs_to :organization
  has_many :inquiries
  has_many :answers
  has_many :notifications

  delegate :name, to: :organization, prefix: true
  delegate :owner_first_name, to: :organization
  accepts_nested_attributes_for :organization

  scope :with_phone_number, -> { where.not(phone_number: nil) }

  def outstanding_inquiry
    inquiries.unanswered.first
  end

  def receive_message(body:)
    organization.send_message(to: phone_number, body: body)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def phone_number
    super || ""
  end
end
