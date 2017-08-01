class Conversation < ApplicationRecord
  belongs_to :contact
  belongs_to :inbox
  belongs_to :phone_number

  has_many :messages
  has_many :read_receipts

  has_one :recent_message,
          -> { by_recency.limit(1) }, class_name: 'Message'

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
    contact.open_conversations.where(phone_number: phone_number).none?
  end

  def create_message(message, sender, campaign, manual_message)
    messages.create(
      message_params(message, sender, campaign, manual_message)
    ).tap(&:touch_conversation)
  end

  private

  def message_params(message, sender, campaign, manual_message)
    base_message_params(message).merge(
      sent_at: message.date_sent,
      external_created_at: message.date_created,
      sender: sender,
      recipient: person,
      campaign: campaign,
      manual_message: manual_message
    )
  end

  def base_message_params(message)
    %i[sid body direction to from].each_with_object({}) do |key, hash|
      hash[key] = message.send(key)
    end
  end
end
