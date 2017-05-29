class Person::ZipCode < Person::Attribute
  def humanize_attribute(*)
    candidacy.zipcode
  end

  def query
    :zipcode
  end

  def icon_class
    return 'fa-question' if candidacy.zipcode.blank?

    'fa-map-marker'
  end
end
