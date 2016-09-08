class Sms::SubscriptionsController < Sms::BaseController

  def create
    handle_incoming_message

    if sender.subscribed?
      sender.receive_message(body: already_subscribed)
    else
      ApplicationRecord.transaction do
        sender.update(subscribed: true)
        ensure_candidate
        binding.pry
        AutomatonJob.perform_later(sender, "subscribe")
      end
    end
    head :ok
  end

  def destroy
    handle_incoming_message

    if sender.unsubscribed?
      sender.receive_message(body: not_subscribed)
    else
      sender.update(subscribed: false)
    end
    head :ok
  end

  private

  def handle_incoming_message
    MessageHandlerJob.perform_later(sender, params["MessageSid"])
  end

  def already_subscribed
    "You are already subscribed. Thanks for your interest in #{organization.name}."
  end

  def not_subscribed
    "You were not subscribed to #{organization.name}. To subscribe reply with START."
  end

  def ensure_candidate
    sender.candidate || sender.create_candidate
  end
end
