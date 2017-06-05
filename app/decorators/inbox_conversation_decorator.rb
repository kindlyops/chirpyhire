class InboxConversationDecorator < Draper::Decorator
  delegate_all
  decorates_association :conversation

  delegate :last_message_created_at, to: :conversation
end
