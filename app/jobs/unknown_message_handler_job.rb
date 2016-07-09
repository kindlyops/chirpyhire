class UnknownMessageHandlerJob < ApplicationJob
  queue_as :default

  def perform(sender, message_sid)
    UnknownMessageHandler.call(sender, message_sid)
  end
end
