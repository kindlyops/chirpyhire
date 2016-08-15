class Payment::Job::ProcessSubscription < ApplicationJob
  def perform(subscription)
    Payment::Subscriptions::Process.call(subscription)
  end
end

