class Person::PhoneNumberAttribute < Person::Attribute
  def label
    person.phone_number.phony_formatted
  end

  def icon_class
    return 'fa-question' if person.phone_number.blank?

    'fa-phone'
  end
end
