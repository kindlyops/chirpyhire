class Person::PhoneNumber < Person::Attribute
  def label
    person.phone_number.phony_formatted
  end

  def icon_class
    return 'fa-question' unless person.phone_number.present?

    'fa-phone'
  end
end
