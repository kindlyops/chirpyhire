class Contact::Transportation < Contact::Attribute
  def self.humanize_attributes
    {
      personal_transportation: 'Personal',
      public_transportation: 'Public',
      no_transportation: 'No Transportation'
    }.with_indifferent_access
  end

  def self.icon_classes
    {
      personal_transportation: 'fa-car',
      public_transportation: 'fa-bus',
      no_transportation: 'fa-thumbs-o-up'
    }.with_indifferent_access
  end

  def self.tooltip_labels
    {
      personal_transportation: 'with personal',
      public_transportation: 'with public',
      no_transportation: 'without'
    }.with_indifferent_access
  end

  def tag_attribute(attribute)
    return if attribute.nil?
    tag_attributes[attribute]
  end

  def self.tag_attributes
    {
      personal_transportation: 'Personal Transportation',
      public_transportation: 'Public Transportation',
      no_transportation: 'No Transportation'
    }.with_indifferent_access
  end

  def tag_attributes
    self.class.tag_attributes
  end
end
