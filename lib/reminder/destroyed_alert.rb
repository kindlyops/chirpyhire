class Reminder::DestroyedAlert < Reminder::Alert
  def call
    return if reminder.delete_unsendable?

    super

    reminder.update(destroyed_alert_sent_at: DateTime.current)
  end

  private

  def alert
    ApplicationController.render(
      template: 'reminder_texter/destroyed_alert',
      layout: false,
      assigns: {
        reminder: reminder
      }
    )
  end
end
