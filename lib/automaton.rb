class Automaton

  def self.call(user, trigger)
    new(user, trigger).call
  end

  def call
    rules.each { |rule| rule.perform(user) }
  end

  def initialize(user, trigger)
    @user = user
    @trigger = trigger
  end

  private

  attr_reader :user, :trigger

  def rules
    trigger.rules
  end
end
