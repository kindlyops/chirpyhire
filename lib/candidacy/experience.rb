class Candidacy::Experience < Candidacy::Attribute
  def humanize_attributes
    {
      less_than_one: 'Less than 1 year',
      one_to_five: '1 - 5 years',
      six_or_more: '6+ years',
      no_experience: 'None'
    }.with_indifferent_access
  end

  def icon_classes
    {
      less_than_one: 'fa-battery-quarter',
      one_to_five: 'fa-battery-half',
      six_or_more: 'fa-battery-full',
      no_experience: 'fa-battery-empty'
    }.with_indifferent_access
  end
end
