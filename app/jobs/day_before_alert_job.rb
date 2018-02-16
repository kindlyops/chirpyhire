class DayBeforeAlertJob < ApplicationJob
  def perform(reminder)
    Reminder::DayBeforeAlert.call(reminder)
  end
end
