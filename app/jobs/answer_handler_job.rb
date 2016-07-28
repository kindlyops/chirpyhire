class AnswerHandlerJob < ApplicationJob
  queue_as :default

  def perform(sender, inquiry, message_sid)
    @sender = sender
    message = MessageHandler.call(sender, organization.get_message(message_sid))

    AnswerHandler.call(sender, inquiry, message)
  end

  private

  attr_reader :sender

  def organization
    sender.organization
  end
end
