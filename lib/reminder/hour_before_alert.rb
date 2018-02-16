class Reminder::HourBeforeAlert < Reminder::Alert
  def call
    return unless reminder.send_hour_before_alert?

    super

    reminder.update(hour_before_alert_sent_at: DateTime.current)
  end

  private

  def alert
    'HourBeforeAlert'
  end
end
