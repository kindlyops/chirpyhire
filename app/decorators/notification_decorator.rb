class NotificationDecorator < Draper::Decorator
  delegate_all

  def subtitle
    "Notification sent to #{message.recipient.decorate.to}"
  end
end
