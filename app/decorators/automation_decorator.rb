class AutomationDecorator < Draper::Decorator
  delegate_all
  decorates_association :rules
end
