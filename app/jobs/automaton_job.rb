class AutomatonJob < ApplicationJob
  queue_as :default

  def perform(user, trigger)
    Automaton.call(user, trigger)
  end
end
