class Reminder::UpdatedAlert < Reminder::Alert
  def call
    return if reminder.update_unsendable?

    super

    reminder.update(last_updated_alert_sent_at: DateTime.current)
  end

  private

  def alert
    'Update'
  end
end
