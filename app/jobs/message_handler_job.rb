class MessageHandlerJob < ApplicationJob
  def perform(sender, message_sid, retries: MessageHandler::DEFAULT_RETRIES)
    MessageHandler.new(sender, message_sid, retries: retries).call
  end
end
