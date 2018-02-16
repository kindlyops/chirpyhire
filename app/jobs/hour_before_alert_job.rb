class HourBeforeAlertJob < ApplicationJob
  def perform(reminder)
    Reminder::HourBeforeAlert.call(reminder)
  end
end
