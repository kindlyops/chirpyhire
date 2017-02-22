class Candidacy::Attribute
  def initialize(candidacy)
    @candidacy = candidacy
  end

  attr_reader :candidacy

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
end
