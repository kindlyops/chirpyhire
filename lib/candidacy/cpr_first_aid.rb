class Candidacy::CprFirstAid < Candidacy::Attribute
  def label
    'CPR / 1st Aid'
  end

  def humanize_attribute(*)
    'CPR / 1st Aid'
  end

  def icon_class
    return 'fa-question' unless candidacy.cpr_first_aid.present?

    'fa-medkit'
  end
end
