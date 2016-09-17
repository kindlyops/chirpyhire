# frozen_string_literal: true
class AutomatonJob < ApplicationJob
  def perform(user, trigger)
    Automaton.call(user, trigger)
  end
end
