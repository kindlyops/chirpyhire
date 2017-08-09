class BotDecorator < Draper::Decorator
  delegate_all
  include HeroPatternable

  def created_at
    TimestampDecorator.new(object, :created_at)
  end

  def last_edited_at
    TimestampDecorator.new(object, :last_edited_at)
  end
end
