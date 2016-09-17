# frozen_string_literal: true
module Payment
  module Job
    class UpdateSubscription < ApplicationJob
      def perform(subscription)
        Payment::Subscriptions::Update.call(subscription)
        SurveyAdvancer.call(subscription.organization)
      end
    end
  end
end
