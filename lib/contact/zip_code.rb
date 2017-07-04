class Contact::ZipCode < Contact::Attribute
  def humanize_attribute(*)
    person.zipcode && person.zipcode.zipcode
  end

  def query
    :zipcode
  end

  def icon_class
    return 'fa-question' if person.zipcode.blank?

    'fa-map-marker'
  end
end
