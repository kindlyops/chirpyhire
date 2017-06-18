class AccountDecorator < Draper::Decorator
  delegate_all
  decorates_association :person
  delegate :hero_pattern_classes, to: :person

  def url
    object.avatar && object.avatar.url(:medium)
  end
end
