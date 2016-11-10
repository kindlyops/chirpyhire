class SmsSubscribeJob < ApplicationJob
  def perform(sender, message_sid)
    ApplicationRecord.transaction do
      MessageHandlerJob.perform_now(sender, message_sid)
      sender.update!(subscribed: true)
      sender.create_candidate unless sender.candidate
      AutomatonJob.perform_now(sender, 'subscribe')
    end
  end
end
