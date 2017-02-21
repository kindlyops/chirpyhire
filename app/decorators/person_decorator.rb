class PersonDecorator < Draper::Decorator
  delegate_all
  decorates_association :candidacy

  delegate :button_class, :icon_class, :availability,
  :transportation, :experience, :qualifications,
  :location, :humanize_attribute, to: :candidacy
end
