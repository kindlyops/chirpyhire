class Payment::Subscriptions::Update
  def self.call(subscription)
    new(subscription).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def call
    stripe_subscription.quantity = subscription.quantity
    stripe_subscription.save
  rescue Stripe::StripeError => e
    subscription.update(error: e.message)
    subscription.fail!
  ensure
    subscription
  end

  private

  def stripe_subscription
    @stripe_subscription ||= Stripe::Subscription.retrieve(subscription.stripe_id)
  end

  attr_reader :subscription

  delegate :organization, to: :subscription
end
