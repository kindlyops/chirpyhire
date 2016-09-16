class MessageHandlerJob < ApplicationJob
  def perform(sender, message_sid)
    MessageHandler.new(sender, message_sid).call
  end
end
