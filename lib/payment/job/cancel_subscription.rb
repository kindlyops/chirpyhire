class Payment::Job::CancelSubscription < ApplicationJob
  def perform(subscription)
    Payment::Subscriptions::Cancel.call(subscription)
  end
end
