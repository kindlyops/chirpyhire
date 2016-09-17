# frozen_string_literal: true
class Payment::Job::UpdateSubscription < ApplicationJob
  def perform(subscription)
    Payment::Subscriptions::Update.call(subscription)
    SurveyAdvancer.call(subscription.organization)
  end
end
