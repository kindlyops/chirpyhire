class Contact::CandidacyZipcode < Contact::Attribute
  def humanize_attribute(*)
    candidacy.zipcode
  end

  def label
    candidacy.zipcode || 'Unknown'
  end

  def icon_class
    return 'fa-question' unless candidacy.zipcode.present?

    'fa-map-marker'
  end
end
