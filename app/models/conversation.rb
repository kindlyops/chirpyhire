class Conversation < ApplicationRecord
  belongs_to :organization
  belongs_to :assignee, optional: true, class_name: 'Account'
  has_many :inbox_conversations
  has_many :inboxes, through: :inbox_conversations
  has_many :participants

  enum status: {
    screen: 0, open: 1, pending: 2, closed: 3
  }
end
