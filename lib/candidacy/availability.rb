class Candidacy::Availability < Candidacy::Attribute
  def humanize_attributes
    {
      live_in: 'Live-In',
      hourly: 'Hourly',
      both: 'Both',
      no_availability: 'None'
    }.with_indifferent_access
  end

  def icon_classes
    {
      live_in: 'fa-home',
      hourly: 'fa-clock-o',
      both: 'fa-hourglass-half',
      no_availability: 'fa-hourglass-o'
    }.with_indifferent_access
  end
end
