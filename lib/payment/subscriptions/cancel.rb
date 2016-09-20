class Payment::Subscriptions::Cancel
  def self.call(subscription)
    new(subscription).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def call
    stripe_subscription.delete
    subscription.cancel!
  end

  private

  def stripe_subscription
    @stripe_subscription ||= begin
      Stripe::Subscription.retrieve(subscription.stripe_id)
    end
  end

  attr_reader :subscription
end
