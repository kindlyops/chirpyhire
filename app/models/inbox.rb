class Inbox < ApplicationRecord
  belongs_to :team
  has_many :assignment_rules
  has_many :conversations
  has_many :bot_campaigns

  delegate :name, to: :team

  def existing_open_conversation(contact)
    open_conversation = conversations.opened.find_by(contact: contact)
    open_conversation || recent_conversations.find_by(contact: contact)
  end

  def recent_conversations
    conversations.by_recent_message
  end

  def receive(message)
    InboxDeliveryAgent.call(self, message)
  end
end
