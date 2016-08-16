class Payment::Job::ProcessSubscription < ApplicationJob
  def perform(subscription, email)
    Payment::Subscriptions::Process.call(subscription, email)
  end
end

