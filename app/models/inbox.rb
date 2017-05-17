class Inbox < ApplicationRecord
  has_many :inbox_conversations
  has_many :conversations, through: :inbox_conversations
  belongs_to :account
end
