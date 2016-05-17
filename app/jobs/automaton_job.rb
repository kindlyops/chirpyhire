class AutomatonJob < ActiveJob::Base
  queue_as :default

  def perform(user, observable, event)
    Automaton.call(user, observable, event)
  end
end
