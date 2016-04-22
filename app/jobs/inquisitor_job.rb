class InquisitorJob < ActiveJob::Base
  queue_as :default

  def perform(search_lead, search_question)
    InquiryScheduler.new(search_lead, search_question).call
  end
end
