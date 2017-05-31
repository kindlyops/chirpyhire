class Conversation < ApplicationRecord
  belongs_to :contact
  has_many :inbox_conversations
  has_many :inboxes, through: :inbox_conversations
  has_many :messages
end
