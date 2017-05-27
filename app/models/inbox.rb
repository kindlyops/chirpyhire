class Inbox < ApplicationRecord
  belongs_to :account
  has_many :inbox_conversations

  def to_builder
    Jbuilder.new do |json|
      json.count inbox_conversations.count
      json.inbox_conversations inbox_conversations.pluck(:id)
    end
  end
end
