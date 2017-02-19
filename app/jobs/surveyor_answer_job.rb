class SurveyorJob < ApplicationJob
  def perform(subscriber, message_sid)
    message = MessageSyncer.new(
      subscriber.person,
      subscriber.organization,
      message_sid
    ).call

    Surveyor.new(subscriber).consider_answer(message)
  end
end
