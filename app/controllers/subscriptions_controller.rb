class SubscriptionsController < SmsController
  def create
    if candidate.subscribed?
      sender.receive_message(body: already_subscribed)
    else
      AutomatonJob.perform_later(sender, "subscribe")
      sender.receive_message(body: subscription_notice)
      candidate.update(subscribed: true)
      sender.update(subscribed: true)
      candidate.create_activity :subscribe, owner: sender
    end
    head :ok
  end

  def destroy
    if candidate.unsubscribed?
      sender.receive_message(body: not_subscribed)
    else
      candidate.update(subscribed: false)
      sender.update(subscribed: false)
      candidate.create_activity :unsubscribe, owner: sender
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

  def candidate
    @candidate ||= sender.candidate || sender.create_candidate(candidate_persona: organization.candidate_persona)
  end
end
