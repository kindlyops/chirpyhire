class Renderer
  def self.call(template, person)
    new(template: template, person: person).call
  end

  def call
    ERB.new(erbify_body).result(binding)
  end

  def initialize(template:, person:)
    @template = template
    @person = person
  end

  private

  attr_reader :person, :template

  def erbify_body
    template.body.gsub(/{{/, '<%=').gsub(/}}/, '%>')
  end

  def recipient
    person
  end

  def organization
    person.organization
  end
end
