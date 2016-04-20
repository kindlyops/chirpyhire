class InquisitorJob < ActiveJob::Base
  queue_as :default

  def perform(lead, question)
    Inquisitor.new(lead: lead, question: question).call
  end
end
