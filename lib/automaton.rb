class Automaton

  def self.call(person, observable, operation)
    new(person, observable, operation).call
  end

  def call
    triggers.each { |trigger| trigger.fire(person) }
  end

  def initialize(person, observable, operation)
    @person = person
    @observable = observable
    @operation = operation
  end

  private

  attr_reader :person, :observable, :operation

  def triggers
    organization.triggers.where(operation: Trigger.operations[operation]).where("#{collection_trigger} OR #{instance_trigger}")
  end

  def collection_trigger
    "(observable_type = #{observable.class} AND observable_id IS NULL)"
  end

  def instance_trigger
    "(observable_type = #{observable.class} AND observable_id = #{observable.id})"
  end

  def organization
    person.organization
  end
end
