class Automaton

  def self.call(user, observable, event)
    new(user, observable, event).call
  end

  def call
    triggers.each { |trigger| trigger.fire(user) }
  end

  def initialize(user, observable, event)
    @user = user
    @observable = observable
    @event = event
  end

  private

  attr_reader :user, :observable, :event

  def triggers
    organization.triggers.where(event: event).where("#{collection_trigger} OR #{instance_trigger}")
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
