class NotificationDecorator < Draper::Decorator
  delegate_all

  def subtitle
    "Notification sent to #{recipient.decorate.to}"
  end

  def color
    "info"
  end

  def icon_class
    "fa-info"
  end
end
