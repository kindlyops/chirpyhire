class NotificationCreateDecorator < Draper::Decorator
  delegate_all

  def subtitle
    "Notification sent to #{recipient.decorate.from_short}"
  end

  def color
    "info"
  end

  def icon_class
    "fa-info"
  end
end
