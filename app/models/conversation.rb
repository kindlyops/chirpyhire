class Conversation < ApplicationRecord
  belongs_to :contact
  belongs_to :inbox
  belongs_to :phone_number

  has_many :read_receipts
  has_many :parts, class_name: 'ConversationPart'
  has_many :messages, through: :parts
  has_one :recent_conversation_part,
          -> { by_recency.limit(1) }, class_name: 'ConversationPart'

  enum state: {
    'Open' => 0, 'Closed' => 1
  }

  delegate :person, :handle, :organization, to: :contact
  delegate :handle, to: :contact, prefix: true

  accepts_nested_attributes_for :contact

  def contact_phone_number
    contact.phone_number.phony_formatted
  end

  def self.opened
    where(state: 'Open')
  end

  def self.by_recent_conversation_part
    order(last_conversation_part_created_at: :desc)
  end

  def open?
    state == 'Open'
  end

  def closed?
    state == 'Closed'
  end

  def reopenable?
    contact.open_conversations.where(phone_number: phone_number).none?
  end
end
