class AnswersController < SmsController

  def create
    if candidate.present? && inquiry.present?
      create_answer
      continue_search
      head :ok
    else
      error_message
    end
  end

  private

  def continue_search
    InquisitorJob.perform_later(job_candidate, next_job_question)
  end

  def create_answer
    candidate.answers.create(answer_attributes)
  end

  def candidate
    @candidate ||= organization.candidates.find_by(user: sender)
  end

  def inquiry
    @inquiry ||= candidate.most_recent_inquiry
  end

  def answer_attributes
    { body: normalized_body, message: message, question: question }
  end

  def normalized_body
    params["Body"].strip.upcase
  end

  def question
    @question ||= inquiry.question
  end

  def job_question
    job.job_questions.find_by(question: question)
  end

  def job_candidate
    candidate.processing_job_candidate
  end

  def next_job_question
    @next_job_question ||= job.job_question_after(job_question)
  end

  def job
    job_candidate.job
  end
end
