class Candidacy::Availability < Candidacy::Attribute
  def humanize_attributes
    {
      hourly: 'Hourly',
      live_in: 'Live-In',
      both: 'Both',
      no_availability: 'None'
    }.with_indifferent_access
  end

  def icon_classes
    {
      hourly: 'fa-clock-o',
      live_in: 'fa-home',
      both: 'fa-hourglass-half',
      no_availability: 'fa-hourglass-o'
    }.with_indifferent_access
  end
end
