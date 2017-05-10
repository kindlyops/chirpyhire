class Person::ZipCode < Person::Attribute
  def humanize_attribute(*)
    candidacy.zipcode
  end

  def attribute
    :zipcode
  end

  def icon_class
    return 'fa-question' unless candidacy.zipcode.present?

    'fa-map-marker'
  end
end
