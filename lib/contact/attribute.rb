class Contact::Attribute
  def initialize(contact)
    @contact = contact
  end

  def to_s
    label
  end

  attr_reader :contact
  def candidacy
    @candidacy ||= contact.contact_candidacy
  end

  delegate :person, to: :contact

  def humanize_attribute(attribute)
    return if attribute.nil?

    humanize_attributes[attribute]
  end

  def tag_attribute(attribute)
    humanize_attribute(attribute)
  end

  def tooltip_label
    tooltip_labels[query] || label
  end

  def tooltip_labels
    self.class.tooltip_labels
  end

  def self.tooltip_labels
    {}
  end

  def query
    candidacy.send(attribute)
  end

  def attribute
    self.class.to_s.demodulize.underscore.to_sym
  end

  def label
    humanize_attribute(query) || 'Unknown'
  end

  def icon_class
    icon_classes[query] || 'fa-question'
  end

  def button_class
    return 'btn-secondary' if query.present?

    'btn-outline-secondary'
  end

  def humanize_attributes
    self.class.humanize_attributes
  end

  def icon_classes
    self.class.icon_classes
  end
end
