class Candidacy::Subscribed < Candidacy::Attribute
  def initialize(candidacy, organization)
    @candidacy = candidacy
    @organization = organization
  end

  attr_reader :organization

  def id
    candidacy.subscribed_to(organization).id
  end

  def label
    humanize_attribute(actively_subscribed?) || 'Unknown'
  end

  def icon_class
    icon_classes[actively_subscribed?] || 'fa-question'
  end

  def actively_subscribed?
    candidacy.actively_subscribed_to?(organization)
  end

  def button_class
    'btn-secondary'
  end

  def humanize_attributes
    {
      true => 'Subscribed',
      false => 'Unsubscribed'
    }
  end

  def icon_classes
    {
      true => 'fa-mobile subscribed',
      false => 'fa-mobile unsubscribed'
    }
  end
end
