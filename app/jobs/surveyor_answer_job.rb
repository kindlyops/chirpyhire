class SurveyorAnswerJob < ApplicationJob
  def perform(contact, inquiry, message_sid)
    message = MessageSyncer.new(contact, message_sid).call

    Surveyor.new(contact, message).consider_answer(inquiry)
  end
end
