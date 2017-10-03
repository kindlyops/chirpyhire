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
      Plan.find_by(name: name) || create_plan
    end
  end

  def create_plan
    BillingEvent::PlanEvents.new.create(stripe_plan)
  end

  def stripe_plan
    @stripe_plan ||= begin
      Stripe::Plan.create(
        amount: price,
        interval: 'month',
        name: name,
        currency: 'usd',
        id: next_plan_id
      )
    end
  end

  def next_plan_id
    (Plan.all.sort_by { |p| p.stripe_id.to_i }.last.stripe_id.to_i + 1).to_s
  end

  def stripe_subscription
    @stripe_subscription ||= begin
      Stripe::Subscription.retrieve(subscription.stripe_id)
    end
  end

  def name
    "Candidates - #{subscription.tier}"
  end

  def price
    @price ||= subscription.price * 100
  end
end
