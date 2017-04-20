class Caregiver::Availability < Caregiver::Attribute
  def self.humanize_attributes
    {
      live_in: 'Live-In',
      hourly: 'Hourly',
      both: 'Both',
      no_availability: 'No Availability'
    }.with_indifferent_access
  end

  def self.icon_classes
    {
      live_in: 'fa-home',
      hourly: 'fa-clock-o',
      both: 'fa-hourglass-half',
      no_availability: 'fa-hourglass-o'
    }.with_indifferent_access
  end
end
