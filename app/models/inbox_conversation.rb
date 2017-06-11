class InboxConversation < ApplicationRecord
  belongs_to :inbox
  belongs_to :conversation

  has_many :read_receipts

  delegate :contact, :messages, :recent_message, to: :conversation
  delegate :account, to: :inbox

  def self.by_recent_message
    joins(:conversation).order('conversations.last_message_created_at DESC')
  end

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

  def self.read
    where(unread_count: 0)
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
end
