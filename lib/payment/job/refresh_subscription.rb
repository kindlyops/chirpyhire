class Payment::Job::RefreshSubscription < ApplicationJob
  def perform(stripe_id)
    subscription = Subscription.find_by!(stripe_id: stripe_id)

    Payment::Subscriptions::Refresh.call(subscription)
  end
end
