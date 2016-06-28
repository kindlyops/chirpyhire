class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :candidate
  decorates_association :activities

  def name
    if first_name.present?
      "#{first_name} #{last_name}"
    end
  end

  def phone_number
    object.phone_number || ""
  end

  def from
    name || phone_number
  end
  alias :to :from

  def from_short
    first_name || phone_number
  end
  alias :to_short :from_short

  def icon_class
    "fa-user"
  end
end
