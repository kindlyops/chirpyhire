class Job < ActiveRecord::Base
  belongs_to :account
  has_many :job_questions
  has_many :job_candidates
  has_many :candidates, through: :job_candidates
  has_many :questions, through: :job_questions

  delegate :organization, to: :account
  delegate :name, to: :account, prefix: true

  accepts_nested_attributes_for :candidates, :job_questions
  before_create :ensure_title

  def good_fits
    candidates.merge(job_candidates.good_fit)
  end

  def start
    job_candidates.each do |job_candidate|
      InquisitorJob.perform_later(job_candidate, first_job_question)
    end
  end

  def first_job_question
    job_questions.find_by(previous_question: nil)
  end

  def job_question_after(job_question)
    job_questions.find_by(question: job_question.next_question)
  end

  def result
    return "Found caregiver" if good_fits.any?

    "In progress"
  end

  private

  def ensure_title
    return if self.title.present?

    self.title = "#{account.name}'s Job"
  end
end
