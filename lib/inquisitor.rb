class Inquisitor

  def initialize(job_candidate, job_question)
    @job_candidate = job_candidate
    @job_question = job_question
  end

  def call
    if existing_search_in_progress?
      job_candidate.pending!
    elsif search_finished? || recently_answered_any_question_negatively?
      finish_search
    elsif recently_answered_positively?
      ask_next_question
    else
      job_candidate.processing!
      ask_question
    end
  end

  private

  def organization
    job_candidate.organization
  end

  def starting_search?
    job_question.present? && job_question.starting_search?
  end

  attr_reader :job_question, :job_candidate

  def ask_question
    organization.ask(inquiries.build(question: question), prelude: starting_search?)
  end

  def existing_search_in_progress?
    candidate.has_other_search_in_progress?job
  end

  def job
    job_candidate.job
  end

  def search_finished?
    job_question.blank?
  end

  def pending_jobs?
    candidate.has_pending_jobs?
  end

  def start_pending_search
    InquisitorJob.perform_later(
      next_job_candidate,
      next_job_candidate.first_job_question
    )
  end

  def next_job_candidate
    @next_job_candidate ||= candidate.oldest_pending_job_candidate
  end

  def ask_next_question
    InquisitorJob.perform_later(job_candidate, job.job_question_after(job_question))
  end

  def recently_answered_any_question_negatively?
    candidate.recently_answered_negatively?(questions)
  end

  def recently_answered_positively?
    candidate.recently_answered_positively?(question)
  end

  def finish_search
    job_candidate.determine_fit
    job_candidate.finished!
    start_pending_search if pending_jobs?
  end

  def candidate
    @candidate ||= job_candidate.candidate
  end

  def question
    @question ||= job_question.question
  end

  def questions
    job_candidate.job.questions
  end

  def inquiries
    candidate.inquiries
  end
end
