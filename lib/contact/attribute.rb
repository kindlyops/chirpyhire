class Contact::Attribute
  def initialize(contact)
    @contact = contact
  end

  def to_s
    label
  end

  attr_reader :contact
  delegate :person, :organization, to: :contact
  delegate :candidacy, to: :person

  def humanize_attribute(attribute)
    return if attribute.nil?

    humanize_attributes[attribute]
  end

  def attribute
    self.class.to_s.demodulize.underscore.to_sym
  end

  def label
    humanize_attribute(candidacy.send(attribute)) || 'Unknown'
  end

  def icon_class
    icon_classes[candidacy.send(attribute)] || 'fa-question'
  end

  def button_class
    return 'btn-secondary' if candidacy.send(attribute).present?

    'btn-outline-secondary'
  end

  def humanize_attributes
    self.class.humanize_attributes
  end

  def icon_classes
    self.class.icon_classes
  end
end
