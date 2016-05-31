class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :candidate

  def messages
    @messages ||= object.messages.order(created_at: :desc).decorate
  end

  def name
    "#{first_name} #{last_name}"
  end

  def phone_number
    object.phone_number || ""
  end

  def from
    name || phone_number
  end

  def from_short
    first_name || phone_number
  end
end
