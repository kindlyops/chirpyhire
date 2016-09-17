# frozen_string_literal: true
class Payment::Job::CancelSubscription < ApplicationJob
  def perform(subscription)
    Payment::Subscriptions::Cancel.call(subscription)
  end
end
