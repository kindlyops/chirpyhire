class InboxDecorator < Draper::Decorator
  delegate_all
  decorates_association :team

  delegate :url, :hero_pattern_classes, to: :team
end
