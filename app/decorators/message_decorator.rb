class MessageDecorator < Draper::Decorator
  decorates_association :sender

  delegate :hero_pattern_classes, to: :sender, prefix: true
end
