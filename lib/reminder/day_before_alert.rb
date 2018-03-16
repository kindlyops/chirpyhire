class Reminder::DayBeforeAlert < Reminder::Alert
  def call
    Time.use_zone(organization.time_zone) do
      return unless reminder.send_day_before_alert?

      super

      reminder.update(day_before_alert_sent_at: DateTime.current)
    end
  end

  private

  def alert
    ApplicationController.render(
      template: 'reminder_texter/day_before_alert',
      layout: false,
      assigns: {
        reminder: reminder
      }
    )
  end
end
