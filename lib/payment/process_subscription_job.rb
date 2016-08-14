module Payment
  class ProcessSubscriptionJob < ApplicationJob
    def perform(subscription)
      Payment::Subscriptions::Process.call(subscription)
    end
  end
end
