class Candidacy::Availability < Candidacy::Attribute
  def attribute
    :availability
  end

  def humanize_attributes
    {
      full_time: 'Full-Time',
      part_time: 'Part-Time',
      live_in: 'Live-In',
      flexible: 'Flexible',
      no_availability: 'None'
    }
  end
end
