class SubscriptionsController < SmsController
  before_action :message, only: [:create, :destroy]

  def create
    if candidate.subscribed?
      AutomatonJob.perform_later(candidate, "invalid_subscribe")
    else
      candidate.update(subscribed: true)
      AutomatonJob.perform_later(candidate, "subscribe")
    end
    head :ok
  end

  def destroy
    if candidate.unsubscribed?
      AutomatonJob.perform_later(candidate, "invalid_unsubscribe")
    else
      candidate.update(subscribed: false)
      AutomatonJob.perform_later(candidate, "unsubscribe")
    end
    head :ok
  end

  private

  def candidate
    @candidate ||= sender.candidate || sender.create_candidate
  end
end
