class Candidacy::Transportation < Candidacy::Attribute
  def humanize_attributes
    {
      personal_transportation: 'Personal',
      public_transportation: 'Public',
      no_transportation: 'None'
    }.with_indifferent_access
  end

  def icon_classes
    {
      personal_transportation: 'fa-car',
      public_transportation: 'fa-bus',
      no_transportation: 'fa-thumbs-o-up'
    }.with_indifferent_access
  end
end
