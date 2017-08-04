class ConversationPartDecorator < Draper::Decorator
  delegate_all
  decorates_association :message
  delegate :sender_hero_pattern_classes, to: :message
end
