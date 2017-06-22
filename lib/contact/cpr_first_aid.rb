class Contact::CprFirstAid < Contact::Attribute
  def label
    return 'Unknown' if candidacy.cpr_first_aid.nil?
    return 'CPR / 1st Aid' if candidacy.cpr_first_aid.present?

    'No CPR / 1st Aid'
  end

  def to_s
    candidacy.cpr_first_aid.present?.to_s
  end

  def humanize_attribute(*)
    label
  end

  def icon_class
    return 'fa-question' if candidacy.cpr_first_aid.nil?
    return 'fa-medkit' if candidacy.cpr_first_aid.present?

    'fa-times-circle'
  end
end
