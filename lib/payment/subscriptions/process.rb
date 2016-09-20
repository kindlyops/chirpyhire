class Payment::Subscriptions::Process
  def self.call(token, subscription, email, attributes)
    new(token, subscription, email, attributes).call
  end

  def initialize(token, subscription, email, attributes)
    @token = token
    @subscription = subscription
    @email = email
    @attributes = attributes
  end

  def call
    return unless token.present?

    subscription.update!(
      attributes.merge(stripe_id: stripe_subscription.id)
    )
    subscription.activate!
  rescue Stripe::CardError => e
    raise Payment::CardError, e
  end

  private

  attr_reader :subscription, :email, :attributes, :token

  def stripe_subscription
    if organization.stripe_customer_id.blank?
      stripe_customer = create_stripe_customer_with_subscription
      stripe_customer.subscriptions.first
    else
      stripe_customer = find_stripe_customer
      create_stripe_subscription(stripe_customer)
    end
  end

  def find_stripe_customer
    Stripe::Customer.retrieve(organization.stripe_customer_id)
  end

  def create_stripe_customer_with_subscription
    stripe_customer = Stripe::Customer.create(
      source:   token,
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
