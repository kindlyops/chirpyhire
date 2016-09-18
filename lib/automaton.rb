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
    organization.rules.where(trigger: trigger).order(:created_at)
  end

  def organization
    @organization ||= user.organization
  end
end
