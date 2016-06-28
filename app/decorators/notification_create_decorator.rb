class NotificationCreateDecorator < Draper::Decorator
  delegate_all
  decorates_association :recipient

  def subtitle
    "Notification sent to #{recipient.to_short}"
  end

  def color
    "info"
  end

  def icon_class
    "fa-info"
  end
end
