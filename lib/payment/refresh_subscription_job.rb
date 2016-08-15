module Payment
  class RefreshSubscriptionJob < ApplicationJob
    def perform(subscription)
      Payment::Subscriptions::Refresh.call(subscription)
    end
  end
end
