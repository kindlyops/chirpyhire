class SurveyorAnswerJob < ApplicationJob
  def perform(contact, message_sid)
    message = MessageSyncer.new(
      contact.person,
      contact.organization,
      message_sid
    ).call

    Surveyor.new(contact).consider_answer(message)
  end
end
