# frozen_string_literal: true
class AnswerHandlerJob < ApplicationJob
  def perform(sender, inquiry, message_sid)
    @sender = sender
    message = MessageHandler.call(sender, message_sid)

    AnswerHandler.call(sender, inquiry, message)
  end

  private

  attr_reader :sender

  def organization
    sender.organization
  end
end
