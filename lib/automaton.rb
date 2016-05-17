class Automaton

  def self.call(user, observable, operation)
    new(user, observable, operation).call
  end

  def call
    triggers.each { |trigger| trigger.fire(user) }
  end

  def initialize(user, observable, operation)
    @user = user
    @observable = observable
    @operation = operation
  end

  private

  attr_reader :user, :observable, :operation

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
    user.organization
  end
end
