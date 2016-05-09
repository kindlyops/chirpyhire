class AutomatonJob < ActiveJob::Base
  queue_as :default

  def perform(person, observable, operation)
    Automaton.call(person, observable, operation)
  end
end
