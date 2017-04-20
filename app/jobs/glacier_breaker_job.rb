class GlacierBreakerJob < ApplicationJob
  def perform(account)
    GlacierBreaker.call(account)
  end
end
