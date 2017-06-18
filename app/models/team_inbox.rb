class TeamInbox < ApplicationRecord
  belongs_to :team
  has_many :inbox_conversations, class_name: 'TeamInboxConversation'
  has_many :conversations, through: :inbox_conversations
end
