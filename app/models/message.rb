class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :organization, optional: true
  belongs_to :sender, class_name: 'Person', optional: true
  belongs_to :recipient, class_name: 'Person', optional: true
  belongs_to :campaign, optional: true

  counter_culture %i[conversation contact]

  has_many :read_receipts
  has_one :manual_message_participant

  validates :sender, presence: true
  validates :recipient, presence: true, if: :outbound?
  validates :conversation, presence: true
  validate :open_conversation, on: :create
  phony_normalize :to, default_country_code: 'US'
  phony_normalize :from, default_country_code: 'US'

  delegate :handle, to: :sender, prefix: true
  delegate :organization, :contact, to: :conversation

  def self.active
    where('messages.created_at >= ?', 30.days.ago)
  end

  def self.by_recency
    order(external_created_at: :desc).order(:id)
  end

  def self.by_oldest
    order(:external_created_at, :id)
  end

  def self.last_reply_at
    replies.by_recency.first.created_at
  end

  def day
    external_created_at.to_date
  end

  def outbound?
    !inbound?
  end

  def inbound?
    direction == 'inbound'
  end

  def account
    return sender.account if outbound?
    recipient.account
  end

  def person
    return recipient if outbound?
    sender
  end

  def time_ago
    external_created_at.strftime('%I:%M')
  end

  def summary
    body && body[0..30] || ''
  end

  def organization_phone_number
    return organization.phone_numbers.find_by(phone_number: to) if inbound?
    organization.phone_numbers.find_by(phone_number: from)
  end

  private

  def open_conversation
    errors.add(:conversation, 'must be open.') unless conversation.open?
  end
end
