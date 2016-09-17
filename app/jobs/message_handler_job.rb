# frozen_string_literal: true
class MessageHandlerJob < ApplicationJob
  def perform(sender, message_sid)
    MessageHandler.call(sender, message_sid)
  end
end
