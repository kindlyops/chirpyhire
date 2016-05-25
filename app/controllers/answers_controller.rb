class AnswersController < SmsController

  def create
    if answer.valid?
      AutomatonJob.perform_later(sender, trigger)
    else
      sender.receive_message(body: wrong_format_answer)
    end
    head :ok
  end

  private

  def wrong_format_answer
    "We were looking for #{question.format.indefinitize} answer but you sent #{answer.format.indefinitize}. Please answer with #{question.format.indefinitize}."
  end

  def answer
    sender.answer(outstanding_inquiry, params["MessageSid"])
  end

  def outstanding_inquiry
    @outstanding_inquiry ||= sender.outstanding_inquiry
  end

  def question
    outstanding_inquiry.question
  end

  def trigger
    question.trigger
  end

end
