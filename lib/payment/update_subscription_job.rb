module Payment
  class UpdateSubscriptionJob < ApplicationJob
    def perform(subscription)
      Payment::Subscriptions::Update.call(subscription)
    end
  end
end
