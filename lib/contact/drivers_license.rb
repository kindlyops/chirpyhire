class Contact::DriversLicense < Contact::Attribute
  def label
    return 'Unknown' if candidacy.drivers_license.nil?
    return "Driver's License" if candidacy.drivers_license.present?

    "No Driver's License"
  end

  def to_s
    candidacy.drivers_license.present?.to_s
  end

  def humanize_attribute(*)
    label
  end

  def icon_class
    return 'fa-question' if candidacy.drivers_license.nil?
    return 'fa-id-card-o' if candidacy.drivers_license.present?

    'fa-times-circle'
  end
end
