class Conversation < ApplicationRecord
  belongs_to :contact
  belongs_to :inbox

  has_many :messages
  has_many :read_receipts

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
