class Payment::Subscriptions::Refresh
  def self.call(subscription)
    new(subscription).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def call
    subscription.refresh(stripe_subscription: stripe_subscription)
  rescue Stripe::StripeError => e
    subscription.update(error: e.message)
    subscription.fail!
  ensure
    subscription
  end

  private

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(organization.stripe_customer_id)
  end

  def stripe_subscription
    @stripe_subscription ||= stripe_customer.subscriptions.retrieve(subscription.stripe_id)
  end

  attr_reader :subscription, :stripe_subscription

  delegate :organization, to: :subscription
end
