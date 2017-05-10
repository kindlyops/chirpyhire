class Person::Source < Person::Attribute
  def self.humanize_attributes
    {
      my_caregivers: 'My Caregivers',
      network: 'Network'
    }.with_indifferent_access
  end

  def self.icon_classes
    {
      my_caregivers: 'fa-group',
      network: 'fa-globe'
    }.with_indifferent_access
  end
end
