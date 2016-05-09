class Automaton

  def self.call(person, event)
    new(person: person, event: event).call
  end

  def call
    triggers.each { |trigger| trigger.fire(person) }
  end

  def initialize(person:, event:)
    @person = person
    @event = event
  end

  private

  attr_reader :person, :event

  def triggers
    organization.triggers.where("event LIKE #{event}%")
  end

  def organization
    person.organization
  end
end
