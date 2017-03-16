class SurveyorAnswerJob < ApplicationJob
  def perform(contact, inquiry, message_sid)
    message = MessageSyncer.new(
      contact.person,
      contact.organization,
      message_sid
    ).call

    Surveyor.new(contact).consider_answer(inquiry, message)
  end
end
