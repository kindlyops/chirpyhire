class UnknownChirpHandlerJob < ActiveJob::Base
  queue_as :default

  def perform(sender, message_sid)
    UnknownChirpHandler.call(sender, message_sid)
  end
end
