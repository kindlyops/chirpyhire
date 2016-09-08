class AutomatonJob < ApplicationJob
  def perform(user, trigger)
    binding.pry
    Automaton.call(user, trigger)
  end
end
