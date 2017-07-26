class Person::PhoneNumberAttribute < Person::Attribute
  def label
    person.phone_number.phony_formatted
  end
end
