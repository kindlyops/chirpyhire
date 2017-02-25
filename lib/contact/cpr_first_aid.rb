class Contact::CprFirstAid < Contact::Attribute
  def label
    'CPR / 1st Aid'
  end

  def search_label
    label if candidacy.cpr_first_aid.present?
  end

  def humanize_attribute(*)
    label
  end

  def icon_class
    return 'fa-question' if candidacy.cpr_first_aid.nil?

    'fa-medkit'
  end
end
