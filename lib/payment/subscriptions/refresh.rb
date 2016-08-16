class Payment::Subscriptions::Refresh
  def self.call(subscription)
    new(subscription).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def call
    subscription.refresh(stripe_subscription: stripe_subscription)
  end

  private

  def stripe_subscription
    @stripe_subscription ||= Stripe::Subscription.retrieve(subscription.stripe_id)
  end

  attr_reader :subscription
end
