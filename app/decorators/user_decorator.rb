class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :candidate

  def name
    if first_name.present?
      "#{first_name} #{last_name}".squish
    end
  end

  def phone_number
    object.phone_number || ""
  end
end
