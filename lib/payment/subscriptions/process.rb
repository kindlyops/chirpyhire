# frozen_string_literal: true
class Payment::Subscriptions::Process
  def self.call(subscription, email)
    new(subscription, email).call
  end

  def initialize(subscription, email)
    @subscription = subscription
    @email = email
  end

  def call
    if organization.stripe_customer_id.blank?
      stripe_customer = create_stripe_customer_with_subscription
      stripe_subscription = stripe_customer.subscriptions.first
    else
      stripe_customer = find_stripe_customer
      stripe_subscription = create_stripe_subscription(stripe_customer)
    end

    subscription.update(stripe_id: stripe_subscription.id)
  end

  private

  attr_reader :subscription, :email

  def find_stripe_customer
    Stripe::Customer.retrieve(organization.stripe_customer_id)
  end

  def create_stripe_customer_with_subscription
    stripe_customer = Stripe::Customer.create(
      source:   organization.stripe_token,
      plan:     subscription.plan_stripe_id,
      quantity: subscription.quantity,
      description: organization.name,
      email: email
    )
    organization.update(stripe_customer_id: stripe_customer.id)
    stripe_customer
  end

  def create_stripe_subscription(stripe_customer)
    Stripe::Subscription.create(
      customer: stripe_customer.id,
      plan:     subscription.plan_stripe_id,
      quantity: subscription.quantity
    )
  end

  def organization
    @organization ||= subscription.organization
  end
end
