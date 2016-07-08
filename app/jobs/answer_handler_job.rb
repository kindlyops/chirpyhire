class AnswerHandlerJob < ApplicationJob
  queue_as :default

  def perform(sender, inquiry, message_sid)
    AnswerHandler.call(sender, inquiry, message_sid)
  end
end
