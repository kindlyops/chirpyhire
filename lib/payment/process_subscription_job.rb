module Payment
  class ProcessSubscriptionJob < ApplicationJob
    def perform(subscription)
      subscription.process!
    end
  end
end
