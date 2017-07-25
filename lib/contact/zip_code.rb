class Contact::ZipCode < Contact::Attribute
  def label
    person.zipcode&.zipcode
  end

  def icon_class
    return 'fa-question' if person.zipcode.blank?

    'fa-map-marker'
  end
end
