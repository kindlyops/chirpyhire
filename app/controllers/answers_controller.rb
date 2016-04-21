class AnswersController < SmsController

  def create
    if lead.present?
      create_answer

      handle_search
    else
      error_message
    end
  end

  private

  def handle_search
    if next_search_question.blank? && normalized_body == "Y"
      search_lead.good_fit!
    else
      continue_search
    end
  end

  def continue_search
    InquisitorJob.perform_later(search_lead, next_search_question)
  end

  def create_answer
    if inquiry.present?
      lead.answers.create(answer_attributes)
      head :ok
    else
      error_message
    end
  end

  def lead
    @lead ||= organization.leads.find_by(user: sender)
  end

  def inquiry
    @inquiry ||= lead.most_recent_inquiry
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

  def search_lead
    lead.processing_search_lead
  end

  def next_search_question
    @next_search_question ||= search.search_question_after(search_question)
  end

  def search
    search_lead.search
  end
end
