class ReminderUpdatedJob < ApplicationJob
  def perform(reminder)
    Reminder::UpdatedAlert.call(reminder)
  end
end
