class Payment::Subscriptions::Update
  def self.call(subscription, attributes)
    new(subscription, attributes).call
  end

  def initialize(subscription, attributes)
    @subscription = subscription
    @attributes = attributes
  end

  def call
    stripe_subscription.quantity = attributes["quantity"]
    stripe_subscription.save
    subscription.update!(attributes)
  rescue Stripe::CardError => e
    raise Payment::CardError.new(e)
  end

  private

  def stripe_subscription
    @stripe_subscription ||= Stripe::Subscription.retrieve(subscription.stripe_id)
  end

  attr_reader :subscription, :attributes
end
