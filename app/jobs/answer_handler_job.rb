class AnswerHandlerJob < ApplicationJob
  def perform(sender, inquiry, message_sid)
    @sender = sender
    message = MessageHandler.new(sender, message_sid).call

    AnswerHandler.call(sender, inquiry, message)
  end

  private

  attr_reader :sender

  def organization
    sender.organization
  end
end
