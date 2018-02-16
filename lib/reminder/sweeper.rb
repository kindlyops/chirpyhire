class Reminder::Sweeper
  def self.call
    new.call
  end

  def call
    Reminder
      .where(tomorrow)
      .where(tomorrow_time).find_each(&method(:day_before))

    Reminder
      .where(next_hour)
      .where(next_hour_time).find_each(&method(:hour_before))
  end

  def day_before(reminder)
    DayBeforeAlertJob.perform_later(reminder)
  end

  def hour_before(reminder)
    HourBeforeAlertJob.perform_later(reminder)
  end

  def tomorrow
    {
      day_before_alert_sent_at: nil,
      send_day_before_alert: true
    }
  end

  def tomorrow_time
    Reminder.arel_table[:event_at].lteq(day_ahead)
  end

  def next_hour
    {
      hour_before_alert_sent_at: nil,
      send_hour_before_alert: true
    }
  end

  def next_hour_time
    Reminder.arel_table[:event_at].lteq(hour_ahead)
  end

  def day_ahead
    1.day.from_now
  end

  def hour_ahead
    1.hour.from_now
  end
end
