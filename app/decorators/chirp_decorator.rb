class ChirpDecorator < Draper::Decorator
  delegate_all
  decorates_association :activities
end
