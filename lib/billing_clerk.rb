class BillingClerk
  def self.call(invoice)
    new(invoice).call
  end

  def initialize(invoice)
    @invoice = invoice
  end

  attr_reader :invoice
  delegate :subscription, :organization, to: :invoice

  def call
    return if non_standard_invoice?

    item_id = stripe_subscription.items.data[0].id
    items = [{
      id: item_id,
      plan: plan.stripe_id
    }]
    stripe_subscription.items = items
    stripe_subscription.save
  end

  def non_standard_invoice?
    subscription.blank? || organization.invoices.one?
  end

  def plan
    @plan ||= begin
      Plan.find_by(amount: price) || create_plan
    end
  end

  def create_plan
    Stripe::Plan.create(
      amount: price,
      interval: 'month',
      name: "Candidates - #{subscription.tier}",
      currency: 'usd',
      id: next_plan_id
    )
  end

  def next_plan_id
    Plan.order(:id).last.id + 1
  end

  def stripe_subscription
    @stripe_subscription ||= begin
      Stripe::Subscription.retrieve(subscription.stripe_id)
    end
  end

  def price
    @price ||= subscription.price * 100
  end
end
