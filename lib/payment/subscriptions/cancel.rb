class Payment::Subscriptions::Cancel
  def self.call(subscription)
    new(subscription).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def call
    stripe_subscription.delete(at_period_end: true)

    subscription.refresh(stripe_subscription: stripe_subscription)
  end

  private

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(organization.stripe_customer_id)
  end

  def stripe_subscription
    @stripe_subscription ||= stripe_customer.subscriptions.retrieve(subscription.stripe_id)
  end

  attr_reader :subscription

  delegate :organization, to: :subscription
end
