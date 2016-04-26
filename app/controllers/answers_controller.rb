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
    InquisitorJob.perform_later(search_candidate, next_search_question)
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

  def search_question
    search.search_questions.find_by(question: question)
  end

  def search_candidate
    candidate.processing_search_candidate
  end

  def next_search_question
    @next_search_question ||= search.search_question_after(search_question)
  end

  def search
    search_candidate.search
  end
end
