class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  delegate :name, to: :sender, prefix: true

  def sender
    @sender ||= object.sender.decorate
  end
end
