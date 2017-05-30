class InboxConversation < ApplicationRecord
  belongs_to :inbox
  belongs_to :conversation

  has_many :read_receipts

  delegate :contact, :messages, to: :conversation
  delegate :account, to: :inbox

  def self.contact(contact)
    joins(:conversation).where(conversations: { contact: contact })
  end

  def self.unread
    where('inbox_conversations.unread_count > ?', 0)
  end

  def self.recently_viewed
    order('inbox_conversations.last_viewed_at DESC NULLS LAST')
      .order('inbox_conversations.unread_count DESC')
  end

  def self.by_handle
    order('NULLIF(people.name, people.nickname) ASC')
  end

  def self.read
    where(unread_count: 0)
  end

  def days
    messages.by_recency.chunk(&:day).map(&method(:to_day))
  end

  def day(date)
    result = messages.by_recency.chunk(&:day).find do |day, _|
      day == date
    end

    to_day(result)
  end

  def unread?
    unread_count.positive?
  end

  def read?
    !unread?
  end

  def to_builder
    Inbox::ConversationSerializer.new(self)
  end

  private

  def to_day(day)
    Conversation::Day.new(day)
  end
end
