class AnswersController < SmsController

  def create
    if answer.valid?
      AutomatonJob.perform_later(sender, trigger)
      head :ok
    else
      render_sms wrong_format_answer
    end
  end

  private

  def wrong_format_answer
    Messaging::Response.new do |r|
      r.Message "We were looking for #{question.format.indefinitize} answer but you sent #{answer.format.indefinitize}. Please answer with #{question.format.indefinitize}."
    end
  end

  def answer
    outstanding_inquiry.create_answer(user: sender, message_sid: params["MessageSid"])
  end

  def outstanding_inquiry
    @outstanding_inquiry ||= sender.outstanding_inquiry
  end

  def question
    outstanding_inquiry.question
  end

  def trigger
    organization.triggers.find_by(observable: question, event: "answer")
  end

end
