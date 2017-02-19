class Organizations::AnswersController < Organizations::MessagesController
  def create
    SurveyorAnswerJob.perform_later(subscriber, params['MessageSid'])
  end
end
