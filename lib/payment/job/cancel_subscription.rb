# frozen_string_literal: true
module Payment
  module Job
    class CancelSubscription < ApplicationJob
      def perform(subscription)
        Payment::Subscriptions::Cancel.call(subscription)
      end
    end
  end
end
