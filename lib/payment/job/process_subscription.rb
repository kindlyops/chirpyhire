class Payment::Job::ProcessSubscription < ApplicationJob
  def perform(subscription, email)
    Payment::Subscriptions::Process.call(subscription, email)
    SurveyAdvancer.call(subscription.organization)
  end
end

