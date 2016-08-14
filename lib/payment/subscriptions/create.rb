class Payment::Subscriptions::Create
  def self.call(subscription, stripe_token)
    new(subscription, stripe_token).call
  end

  def initialize(subscription, stripe_token)
    @subscription = subscription
    @stripe_token = stripe_token
  end

  def call
    organization.update(stripe_token: stripe_token)
    subscription.save

    Payment::ProcessSubscriptionJob.perform_later(subscription)

    subscription
  end

  private

  attr_reader :subscription, :stripe_token

  delegate :organization, to: :subscription
end
