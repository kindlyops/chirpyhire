class Person < ApplicationRecord
  has_one :contact
  has_one :bot
  has_one :account

  has_many :sent_messages,
           class_name: 'Message', foreign_key: :sender_id, inverse_of: :sender
  has_many :received_messages, class_name: 'Message',
                               foreign_key: :recipient_id,
                               inverse_of: :recipient

  delegate :subscribed?, to: :contact
  delegate :avatar, to: :account, allow_nil: true

  def handle
    return account.handle if account.present?
    return contact.handle if contact.present?
    return bot.handle if bot.present?
  end

  def phone_number
    return account.phone_number if account.present?
    return contact.phone_number if contact.present?
  end
end
