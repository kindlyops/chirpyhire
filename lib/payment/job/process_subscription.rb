class Payment::Job::ProcessSubscription < ApplicationJob
  def perform(subscription)
    subscription.process!
  end
end

