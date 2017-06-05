class ConversationDecorator < Draper::Decorator
  delegate_all
  decorates_association :contact

  delegate :hero_pattern_classes, to: :contact, prefix: true

  def last_message_created_at
    Conversation::LastMessageCreatedAt.new(object)
  end
end
