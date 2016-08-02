class User < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  belongs_to :organization

  has_one :candidate
  has_one :referrer
  has_one :account
  has_many :messages
  has_many :inquiries, through: :messages
  has_many :answers, through: :messages
  has_many :notifications, through: :messages

  delegate :name, :phone_number, :survey, to: :organization, prefix: true

  accepts_nested_attributes_for :organization

  def self.by_having_unread_messages
    order(has_unread_messages: :desc)
  end

  def self.has_unread_messages
    where(has_unread_messages: true)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def outstanding_inquiry
    inquiries.unanswered.first
  end

  def last_answer
    answers.by_recency.first || NullAnswer.new
  end

  def receive_message(body:)
    message = organization.send_message(to: phone_number, body: body)
    message.user = self
    message.save
    Threader.new(message).call

    message
  end

  def unsubscribed?
    !subscribed?
  end
end
