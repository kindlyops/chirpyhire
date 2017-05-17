class Person::Availability < Person::Attribute
  def self.humanize_attributes
    {
      live_in: 'Live-In',
      hourly: 'AM/PM',
      hourly_am: 'AM',
      hourly_pm: 'PM',
      any_shift: 'Open'
    }.with_indifferent_access
  end

  def self.icon_classes
    {
      live_in: 'fa-home',
      hourly: 'fa-clock-o',
      hourly_am: 'fa-sun-o',
      hourly_pm: 'fa-moon-o',
      any_shift: 'fa-flag-checkered'
    }.with_indifferent_access
  end

  def query_array
    if query == 'hourly'
      %w(hourly_am hourly_pm)
    else
      [query]
    end
  end

  def self.tooltip_labels
    {
      live_in: 'looking for live-in shifts',
      hourly: 'looking for any shift',
      hourly_am: 'looking for AM shifts',
      hourly_pm: 'looking for PM shifts',
      any_shift: 'looking for any shift'
    }.with_indifferent_access
  end
end