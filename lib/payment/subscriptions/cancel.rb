# frozen_string_literal: true
class Payment::Subscriptions::Cancel
  def self.call(subscription)
    new(subscription).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def call
    stripe_subscription.delete
  end

  private

  def stripe_subscription
    @stripe_subscription ||= Stripe::Subscription.retrieve(subscription.stripe_id)
  end

  attr_reader :subscription
end
