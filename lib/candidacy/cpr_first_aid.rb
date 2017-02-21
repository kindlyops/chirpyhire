class Candidacy::CprFirstAid < Candidacy::Attribute
  def label
    'CPR / 1st Aid'
  end

  def humanize_attribute(*)
    'CPR / 1st Aid'
  end

  def icon_class
    return 'fa-question' if candidacy.cpr_first_aid.nil?

    'fa-medkit'
  end
end
