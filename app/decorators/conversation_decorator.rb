class ConversationDecorator < Draper::Decorator
  delegate_all
  decorates_association :contact

  def last_message_created_at
    Conversation::LastMessageCreatedAt.new(object)
  end
end
