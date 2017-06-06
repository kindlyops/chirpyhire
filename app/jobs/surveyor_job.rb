class SurveyorJob < ApplicationJob
  def perform(contact, message_sid)
    MessageSyncer.call(contact, message_sid)

    Surveyor.new(contact).start
  end
end
