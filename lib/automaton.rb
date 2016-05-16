class Automaton

  def self.call(observable, operation)
    new(observable, operation).call
  end

  def call
    triggers.each { |trigger| trigger.fire(user) }
  end

  def initialize(observable, operation)
    @observable = observable
    @operation = operation
  end

  private

  attr_reader :observable, :operation

  def triggers
    organization.triggers.where(operation: Trigger.operations[operation]).where("#{collection_trigger} OR #{instance_trigger}")
  end

  def collection_trigger
    "(observable_type = '#{observable.class}' AND observable_id IS NULL)"
  end

  def instance_trigger
    "(observable_type = '#{observable.class}' AND observable_id = #{observable.id})"
  end

  def organization
    observable.organization
  end
end
