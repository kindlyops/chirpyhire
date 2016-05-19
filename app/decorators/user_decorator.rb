class UserDecorator < Draper::Decorator
  delegate_all

  def name
    "#{first_name} #{last_name}"
  end

  def phone_number
    object.phone_number || ""
  end
end
