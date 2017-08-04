class ConversationDecorator < Draper::Decorator
  delegate_all
  decorates_association :contact

  delegate :hero_pattern_classes, to: :contact, prefix: true

  def last_conversation_part_created_at
    Conversation::LastConversationPartCreatedAt.new(object)
  end
end
