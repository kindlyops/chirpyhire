class Inbox < ApplicationRecord
  belongs_to :account
  has_many :inbox_conversations
  has_many :conversations, through: :inbox_conversations

  def existing_open_conversation(contact)
    open_conversation = conversations.opened.find_by(contact: contact)
    open_conversation || recent_conversations.find_by(contact: contact)
  end

  def recent_conversations
    conversations.by_recent_message
  end

  def recent_inbox_conversations
    inbox_conversations.by_recent_message
  end

  def to_builder
    conversations_json = recent_conversations.limit(25).map do |c|
      c.inbox_conversations.find_by(inbox: self).to_builder.attributes!
    end

    Jbuilder.new do |json|
      json.id id
      json.conversations_count conversations.count
      json.conversations conversations_json
    end
  end
end
