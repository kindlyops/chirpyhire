# frozen_string_literal: true
module Payment
  module Job
    class ProcessSubscription < ApplicationJob
      def perform(subscription, email)
        Payment::Subscriptions::Process.call(subscription, email)
        SurveyAdvancer.call(subscription.organization)
      end
    end
  end
end
