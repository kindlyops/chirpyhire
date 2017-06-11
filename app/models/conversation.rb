class Conversation < ApplicationRecord
  belongs_to :contact
  has_many :inbox_conversations
  has_many :inboxes, through: :inbox_conversations
  has_many :messages
  has_one :recent_message,
          -> { by_recency.limit(1) }, class_name: 'Message'

  delegate :person, :handle, :team, to: :contact
  delegate :handle, to: :contact, prefix: true

  def contact_phone_number
    contact.phone_number.phony_formatted
  end

  enum state: {
    'Open' => 0, 'Closed' => 1
  }

  def self.opened
    where(state: 'Open')
  end

  def self.by_recent_message
    order(last_message_created_at: :desc)
  end

  def unread_count(inbox)
    inbox_conversations.find_by(inbox: inbox).unread_count
  end

  def open?
    state == 'Open'
  end

  def closed?
    state == 'Closed'
  end

  def reopenable?
    contact.open_conversations.none?
  end
end
