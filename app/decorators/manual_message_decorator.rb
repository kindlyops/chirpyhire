class ManualMessageDecorator < Draper::Decorator
  delegate_all

  def created_at
    TimestampDecorator.new(object, :created_at)
  end
end
