class Sms::SubscriptionsController < Sms::BaseController
  def create
    if sender.subscribed?
      MessageHandlerJob.perform_now(sender, params['MessageSid'])
      sender.receive_message(body: already_subscribed)
    else
      SmsSubscribeJob.perform_later(sender, params['MessageSid'])
    end
    head :ok
  end

  def destroy
    MessageHandlerJob.perform_now(sender, params['MessageSid'])
    if sender.unsubscribed?
      sender.receive_message(body: not_subscribed)
    else
      sender.update!(subscribed: false)
    end
    head :ok
  end

  private

  def already_subscribed
    'You are already subscribed. '\
    "Thanks for your interest in #{organization.name}."
  end

  def not_subscribed
    'You were not subscribed to '\
    "#{organization.name}. To subscribe reply with 'START'."
  end
end
