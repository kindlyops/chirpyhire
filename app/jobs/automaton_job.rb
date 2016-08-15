class AutomatonJob < ApplicationJob
  def perform(user, trigger)
    Automaton.call(user, trigger)
  end
end
