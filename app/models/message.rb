class Message < ApplicationRecord
  belongs_to :sender, class_name: 'Person', optional: true
  belongs_to :recipient, class_name: 'Person', optional: true
  belongs_to :conversation

  has_many :read_receipts

  validates :sender, presence: true
  validates :recipient, presence: true, if: :outbound?
  validates :conversation, presence: true

  delegate :handle, to: :sender, prefix: true

  def self.by_recency
    order(:external_created_at, :id)
  end

  def self.manual
    where.not(sender: Chirpy.person)
  end

  def self.replies
    where(direction: 'inbound')
  end

  def author
    return :bot if outbound? && sender == Chirpy.person
    return :organization if outbound?
    :person
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

  def self.last_reply_at
    replies.by_recency.last.created_at
  end

  def time_ago
    external_created_at.strftime('%I:%M')
  end

  def conversation_day
    Conversation::Day.new([created_at.to_date, [self]])
  end

  def summary
    body && body[0..30] || ''
  end

  def touch_conversation
    conversation.update(last_message_created_at: created_at)
  end
end
