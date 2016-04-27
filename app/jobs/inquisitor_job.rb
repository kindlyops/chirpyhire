class InquisitorJob < ActiveJob::Base
  queue_as :default

  def perform(job_candidate, job_question)
    InquiryScheduler.new(job_candidate, job_question).call
  end
end
