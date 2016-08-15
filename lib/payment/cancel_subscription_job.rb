module Payment
  class CancelSubscriptionJob < ApplicationJob
    def perform(subscription)
      Payment::Subscriptions::Cancel.call(subscription)
    end
  end
end
