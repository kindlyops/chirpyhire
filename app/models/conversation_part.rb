class ConversationPart < ApplicationRecord
  belongs_to :message
  belongs_to :conversation
  validates :conversation, presence: true
  delegate :sender, :recipient, :body, :sender_id,
           :sender_handle, :direction, to: :message
  delegate :contact, to: :conversation

  def self.by_recency
    order(happened_at: :desc).order(:id)
  end

  def self.by_oldest
    order(:happened_at, :id)
  end

  def touch_conversation
    conversation.update(last_conversation_part_created_at: created_at)

    Broadcaster::Conversation.broadcast(conversation)
  end

  private

  def open_conversation
    errors.add(:conversation, 'must be open.') unless conversation.open?
  end
end
