class Reminder::DestroyedAlert < Reminder::Alert
  def call
    return if reminder.delete_unsendable?

    super

    reminder.update(destroyed_alert_sent_at: DateTime.current)
  end

  private

  def alert
    'Destroy'
  end
end
