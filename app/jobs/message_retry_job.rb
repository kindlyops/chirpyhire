class MessageRetryJob < ApplicationJob
  DEFAULT_RETRIES = 3

  rescue_from(Twilio::REST::RequestError) do |e|
    self.retries_remaining -= 1
    raise unless e.code == 20_404 && retries_remaining.positive?
    retry_job
  end

  protected

  attr_accessor :retries_remaining

  def retry_job
    retry_with(self.class.backoff, retries_remaining)
  end
end
