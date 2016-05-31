class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  delegate :name, to: :sender, prefix: true
  delegate :name, :phone_number, to: :user, prefix: true

  def sender
    @sender ||= object.sender.decorate
  end

  def color
    "complete"
  end

  def icon_class
    "fa-envelope"
  end
end
