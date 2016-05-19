class Automaton

  def self.call(user, trigger, event)
    new(user, trigger, event).call
  end

  def call
    rules.each { |rule| rule.perform(user) }
  end

  def initialize(user, trigger, event)
    @user = user
    @trigger = trigger
    @event = event
  end

  private

  attr_reader :user, :trigger, :event

  def rules
    organization.rules.where(event: event).where("#{collection_rule} OR #{instance_rule}")
  end

  def collection_rule
    "(trigger_type = '#{trigger.class}' AND trigger_id IS NULL)"
  end

  def instance_rule
    "(trigger_type = '#{trigger.class}' AND trigger_id = #{trigger.id})"
  end

  def organization
    user.organization
  end
end
