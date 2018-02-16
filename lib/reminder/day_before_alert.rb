class Reminder::DayBeforeAlert < Reminder::Alert
  def call
    return unless reminder.send_day_before_alert?

    super

    reminder.update(day_before_alert_sent_at: DateTime.current)
  end

  private

  def alert
    'DayBefore'
  end
end
