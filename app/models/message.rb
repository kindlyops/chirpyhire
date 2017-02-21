class Message < ApplicationRecord
  belongs_to :person
  belongs_to :organization

  def self.by_recency
    order(external_created_at: :desc, id: :desc)
  end

  def self.replies
    where(direction: 'inbound')
  end

  def self.last_reply_at
    replies.by_recency.first.created_at
  end

  def time_ago
    external_created_at.strftime('%I:%M')
  end
end
