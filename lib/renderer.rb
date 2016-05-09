class Renderer
  def self.call(template, person)
    new(template: template, person: person).call
  end

  def call
    template.body
  end

  def initialize(template:, person:)
    @template = template
    @person = person
  end

  private

  attr_reader :person, :template
end
