class InquisitorJob < ActiveJob::Base
  queue_as :default

  def perform(search_candidate, search_question)
    InquiryScheduler.new(search_candidate, search_question).call
  end
end
