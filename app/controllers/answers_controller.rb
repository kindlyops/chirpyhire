class AnswersController < SmsController

  def create
    if lead.present?
      create_answer
    else
      error_message
    end
  end

  private

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
    { body: params["Body"], message: message, question: inquiry.question }
  end
end
