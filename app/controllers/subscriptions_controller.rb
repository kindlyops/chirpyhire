class SubscriptionsController < SmsController
  def create
    if sender.subscribed?
      sender.receive_message(body: already_subscribed)
    else
      AutomatonJob.perform_later(sender, "subscribe")
      sender.receive_message(body: subscription_notice)
      sender.update(subscribed: true)
      ensure_candidate
    end
    head :ok
  end

  def destroy
    if sender.unsubscribed?
      sender.receive_message(body: not_subscribed)
    else
      sender.update(subscribed: false)
      sender.receive_message(body: unsubscribed_notice)
    end
    head :ok
  end

  private

  def subscription_notice
    "If you ever wish to stop receiving text messages from #{organization.name} just reply STOP."
  end

  def unsubscribed_notice
    "You are unsubscribed. To subscribe reply with START. Thanks for your interest in #{organization.name}."
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
