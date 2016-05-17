class AutomatonJob < ActiveJob::Base
  queue_as :default

  def perform(user, observable, operation)
    Automaton.call(user, observable, operation)
  end
end
