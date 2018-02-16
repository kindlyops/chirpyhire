class Reminder::Update < Reminder::Base
  def self.call(reminder, attributes)
    new(reminder, attributes).call
  end

  def initialize(reminder, attributes)
    @reminder = reminder
    @attributes = attributes
  end

  attr_reader :attributes

  def call
    return if reminder.new_record?

    if reminder.update(attributes)
      more_than_one_day_out if more_than_one_day_out?
      more_than_one_hour_out if less_than_day_but_more_than_one_hour_out?
      less_than_one_hour_out if less_than_one_hour_out?
      true
    else
      false
    end
  end

  def less_than_one_hour_out
    schedule_updated_alert
    reminder.update(send_day_before_alert: false)
    reminder.update(send_hour_before_alert: false)
  end

  def more_than_one_hour_out
    schedule_updated_alert
    reminder.update(send_day_before_alert: false)
  end

  def more_than_one_day_out
    schedule_updated_alert
  end

  def schedule_updated_alert
    ReminderUpdatedJob.perform_later(reminder)
  end
end
