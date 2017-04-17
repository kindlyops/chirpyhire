class Message < ApplicationRecord
  belongs_to :person
  belongs_to :organization
  belongs_to :sender
  belongs_to :recipient

  def self.by_recency
    order(:external_created_at, :id)
  end

  def self.replies
    where(direction: 'inbound')
  end

  def author
    return :organization if outbound? && manual?
    return :bot if outbound?
    :person
  end

  def day
    external_created_at.to_date
  end

  def outbound?
    !inbound?
  end

  def inbound?
    direction == 'inbound'
  end

  def self.last_reply_at
    replies.by_recency.last.created_at
  end

  def time_ago
    external_created_at.strftime('%I:%M')
  end
end
