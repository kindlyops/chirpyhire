class JobCandidate < ActiveRecord::Base
  belongs_to :job
  belongs_to :candidate

  delegate :organization, to: :candidate
  delegate :first_job_question, to: :job

  enum status: [:pending, :processing, :finished]
  enum fit: [:possible_fit, :bad_fit, :good_fit]

  def determine_fit
    return bad_fit! if is_bad_fit?
    return good_fit! if is_good_fit?
    possible_fit!
  end

  private

  def is_good_fit?
    candidate.answers.to(job.questions).recent.positive.count == job.questions.count
  end

  def is_bad_fit?
    candidate.answers.to(job.questions).recent.negative.exists?
  end
end
