class ConversationPart < ApplicationRecord
  belongs_to :message
  belongs_to :conversation
  validates :conversation, presence: true
  validate :open_conversation, on: :create

  def touch_conversation
    conversation.update(last_message_created_at: created_at)

    Broadcaster::Conversation.broadcast(conversation)
  end

  private

  def open_conversation
    errors.add(:conversation, 'must be open.') unless conversation.open?
  end
end
