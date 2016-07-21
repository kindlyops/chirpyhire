class SubscriptionsController < SmsController
  def create
    if sender.subscribed?
      sender.receive_message(body: already_subscribed)
    else
      ApplicationRecord.transaction do
        sender.update(subscribed: true)
        ensure_candidate
        sender.receive_message(body: subscription_notice)
        AutomatonJob.perform_later(sender, "subscribe")
      end
    end
    head :ok
  end

  def destroy
    if sender.unsubscribed?
      sender.receive_message(body: not_subscribed)
    else
      sender.update(subscribed: false)
    end
    head :ok
  end

  private

  def subscription_notice
    "If you ever wish to stop receiving text messages from #{organization.name} just reply STOP."
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
