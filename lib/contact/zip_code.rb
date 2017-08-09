class Contact::ZipCode < Contact::Attribute
  delegate :zipcode, to: :contact

  def label
    zipcode&.zipcode
  end

  def icon_class
    return 'fa-question' if zipcode.blank?

    'fa-map-marker'
  end
end
