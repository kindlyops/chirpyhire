class TaskDecorator < Draper::Decorator
  delegate_all
  decorates_association :message
end
