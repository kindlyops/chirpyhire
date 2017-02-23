class Candidacy::Status < Candidacy::Attribute
  def initialize(candidacy, organization)
    @candidacy = candidacy
    @organization = organization
  end

  attr_reader :organization

  def label
    humanize_attribute(candidacy.status_for(organization)) || 'Unknown'
  end

  def icon_class
    icon_classes[candidacy.status_for(organization)] || 'fa-question'
  end

  def button_class
    'btn-secondary'
  end

  def humanize_attributes
    {
      ideal: 'Ideal',
      promising: 'Promising'
    }
  end

  def icon_classes
    {
      ideal: 'fa-trophy',
      promising: 'fa-star-half-o'
    }
  end
end
