class Inbox < ApplicationRecord
  belongs_to :account
  has_many :inbox_conversations

  def to_builder
    conversations = inbox_conversations.map do |c| 
      c.to_builder.attributes!
    end
    
    Jbuilder.new do |json|
      json.conversations_count conversations.count
      json.conversations conversations
    end
  end
end
