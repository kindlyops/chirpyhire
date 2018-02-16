class Reminder::Destroy < Reminder::Base
  def self.call(reminder)
    new(reminder).call
  end

  def initialize(reminder)
    @reminder = reminder
  end

  attr_reader :reminder

  def call
    return if reminder.new_record?

    if reminder.destroy
      schedule_destroyed_alert

      more_than_one_day_out if more_than_one_day_out?
      more_than_one_hour_out if less_than_day_but_more_than_one_hour_out?
      true
    else
      false
    end
  end

  def more_than_one_hour_out
    reminder.update(send_hour_before_alert: false)
  end

  def more_than_one_day_out
    reminder.update(send_day_before_alert: false)
    reminder.update(send_hour_before_alert: false)
  end

  def schedule_destroyed_alert
    ReminderDestroyedJob.perform_later(reminder)
  end
end
