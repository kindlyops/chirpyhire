class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :candidate

  def phone_number
    if object.phone_number
      object.phone_number.phony_formatted
    else
      ""
    end
  end
end
