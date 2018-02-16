class ReminderDestroyedJob < ApplicationJob
  def perform(reminder)
    Reminder::DestroyedAlert.call(reminder)
  end
end
