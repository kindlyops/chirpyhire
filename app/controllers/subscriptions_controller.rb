class SubscriptionsController < SmsController
  def create
    if candidate.subscribed?
      render text: messaging_response.already_subscribed
    else
      candidate.update(subscribed: true)
      AutomatonJob.perform_later(candidate, "subscribe")
      render text: messaging_response.subscription_notice
    end
  end

  def destroy
    if candidate.unsubscribed?
      render text: messaging_response.not_subscribed
    else
      candidate.update(subscribed: false)
      render text: messaging_response.unsubscribed_notice
    end
  end

  private

  def messaging_response
    @messaging_response ||= Messaging::Response.new(subject: candidate)
  end

  def candidate
    @candidate ||= sender.candidate || sender.create_candidate
  end
end
