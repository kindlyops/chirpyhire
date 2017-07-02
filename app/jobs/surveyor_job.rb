class SurveyorJob < ApplicationJob
  def perform(contact, message_sid)
    message = MessageSyncer.call(contact, message_sid)

    Surveyor.new(contact, message).start
  end
end
