class SubscriptionsController < SmsController
  before_action :message, only: [:create, :destroy]

  def create
    if candidate.subscribed?
      AutomatonJob.perform_later(sender, candidate.subscription, "invalid_subscribe")
    else
      candidate.subscribe
      AutomatonJob.perform_later(sender, candidate.subscription, "subscribe")
    end
    head :ok
  end

  def destroy
    if candidate.unsubscribed?
      AutomatonJob.perform_later(sender, candidate.subscription, "invalid_unsubscribe")
    else
      candidate.unsubscribe
      AutomatonJob.perform_later(sender, candidate.subscription, "unsubscribe")
    end
    head :ok
  end

  private

  def candidate
    @candidate ||= sender.candidate || sender.create_candidate
  end
end
