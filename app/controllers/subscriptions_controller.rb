class SubscriptionsController < SmsController
  def create
    if candidate.subscribed?
      render_sms already_subscribed
    else
      candidate.update(subscribed: true)
      AutomatonJob.perform_later(sender, candidate, "subscribe")
      render_sms subscription_notice
    end
  end

  def destroy
    if candidate.unsubscribed?
      render_sms not_subscribed
    else
      candidate.update(subscribed: false)
      render_sms unsubscribed_notice
    end
  end

  private

  def subscription_notice
    Messaging::Response.new do |r|
      r.Message "If you ever wish to stop receiving text messages from #{organization.name} just reply STOP."
    end
  end

  def unsubscribed_notice
    Messaging::Response.new do |r|
      r.Message "You are unsubscribed. To subscribe reply with START. Thanks for your interest in #{organization.name}."
    end
  end

  def already_subscribed
    Messaging::Response.new do |r|
      r.Message "You are already subscribed. Thanks for your interest in #{organization.name}."
    end
  end

  def not_subscribed
    Messaging::Response.new do |r|
      r.Message "You were not subscribed to #{organization.name}. To subscribe reply with START."
    end
  end

  def candidate
    @candidate ||= sender.candidate || sender.create_candidate
  end
end
