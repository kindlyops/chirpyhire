module Payment
  class UpdateSubscriptionJob < ApplicationJob
    def perform(subscription)
      subscription.process!
    end
  end
end
