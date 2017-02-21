class Candidacy::Availability < Candidacy::Attribute
  def humanize_attributes
    {
      full_time: 'Full-Time',
      part_time: 'Part-Time',
      live_in: 'Live-In',
      flexible: 'Flexible',
      no_availability: 'None'
    }.with_indifferent_access
  end

  def icon_classes
    {
      full_time: 'fa-hourglass',
      part_time: 'fa-hourglass-end',
      live_in: 'fa-home',
      flexible: 'fa-hourglass-half',
      no_availability: 'fa-hourglass-o'
    }.with_indifferent_access
  end
end
