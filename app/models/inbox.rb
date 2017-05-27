class Inbox < ApplicationRecord
  belongs_to :account
  has_many :inbox_conversations
end
