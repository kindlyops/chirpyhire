class AutomatonJob < ApplicationJob
  def perform(user, trigger)
    Automaton.new(user, trigger).call
  end
end
