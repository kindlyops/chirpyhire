class Contact::Availability < Contact::Attribute
  def self.humanize_attributes
    {
      live_in: 'Live-In',
      hourly: 'Hourly',
      no_availability: 'No Availability',
      hourly_am: 'Hourly - AM',
      hourly_pm: 'Hourly - PM',
      open: 'Open'
    }.with_indifferent_access
  end

  def self.icon_classes
    {
      live_in: 'fa-home',
      hourly: 'fa-clock-o',
      no_availability: 'fa-hourglass-o',
      hourly_am: 'fa-sun-o',
      hourly_pm: 'fa-moon-o',
      open: 'fa-flag-checkered'
    }.with_indifferent_access
  end
end
