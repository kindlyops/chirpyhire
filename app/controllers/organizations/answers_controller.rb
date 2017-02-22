class Organizations::AnswersController < Organizations::MessagesController
  def create
    SurveyorAnswerJob.perform_later(contact, params['MessageSid'])
  end
end
