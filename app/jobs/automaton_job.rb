class AutomatonJob < ActiveJob::Base
  queue_as :default

  def perform(observable, operation)
    Automaton.call(observable, operation)
  end
end
