class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :sender
  delegate :hero_pattern_classes, to: :sender, prefix: true
end
