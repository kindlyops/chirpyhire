class Candidacy::Attribute
  def initialize(candidacy)
    @candidacy = candidacy
  end

  attr_reader :candidacy

  def label
    humanize_attribute(candidacy.send(:attribute)) || 'Unknown'
  end

  def button_class
    return 'btn-secondary' if candidacy.send(attribute)

    'btn-outline-secondary'
  end
end
