class Teams::AnswersController < Teams::MessagesController
  def create
    SurveyorAnswerJob.perform_later(contact, inquiry, params['MessageSid'])

    head :ok
  end

  private

  def inquiry
    contact.person_inquiry
  end
end
