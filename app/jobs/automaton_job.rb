class AutomatonJob < ActiveJob::Base
  queue_as :default

  def perform(person, event)
    Automaton.call(person, event)
  end
end
