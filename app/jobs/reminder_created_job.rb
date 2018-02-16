class ReminderCreatedJob < ApplicationJob
  def perform(reminder)
    Reminder::CreatedAlert.call(reminder)
  end
end
