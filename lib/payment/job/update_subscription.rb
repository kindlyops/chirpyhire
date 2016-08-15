class Payment::Job::UpdateSubscription < ApplicationJob
  def perform(subscription)
    Payment::Subscriptions::Update.call(subscription)
  end
end
