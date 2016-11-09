class Automaton
  def initialize(user, trigger)
    @user = user
    @trigger = trigger
  end

  def call
    rules.each { |rule| rule.perform(user) }
  end

  private

  attr_reader :user, :trigger

  def rules
    user.organization.rules.where(trigger: trigger).order(:created_at)
  end
end
