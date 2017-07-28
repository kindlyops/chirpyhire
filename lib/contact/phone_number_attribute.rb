class Contact::PhoneNumberAttribute < Contact::Attribute
  def label
    contact.phone_number.phony_formatted
  end
end
