class Reminder::CreatedAlert < Reminder::Alert
  def call
    return if reminder.create_unsendable?

    super

    reminder.update(created_alert_sent_at: DateTime.current)
  end

  private

  def alert
    ApplicationController.render(
      template: 'reminder_texter/created_alert',
      layout: false,
      assigns: {
        reminder: reminder
      }
    )
  end
end
