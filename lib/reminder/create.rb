class Reminder::Create < Reminder::Base
  def call
    return if reminder.persisted?

    if reminder.save
      more_than_one_day_out if more_than_one_day_out?
      more_than_one_hour_out if less_than_day_but_more_than_one_hour_out?
      less_than_one_hour_out if less_than_one_hour_out?
      true
    else
      false
    end
  end

  def less_than_one_hour_out
    schedule_created_alert
    reminder.update(send_day_before_alert: false)
    reminder.update(send_hour_before_alert: false)
  end

  def more_than_one_hour_out
    schedule_created_alert
    reminder.update(send_day_before_alert: false)
  end

  def more_than_one_day_out
    schedule_created_alert
  end

  def schedule_created_alert
    ReminderCreatedJob.perform_later(reminder)
  end
end
