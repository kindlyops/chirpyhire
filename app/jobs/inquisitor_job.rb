class InquisitorJob < ActiveJob::Base
  queue_as :default

  def perform(search_lead, search_question)
    Inquisitor.new(search_lead: search_lead, search_question: search_question).call
  end
end
