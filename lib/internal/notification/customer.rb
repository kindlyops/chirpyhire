class Internal::Notification::Customer
  def self.call(organization)
    new(organization).call
  end

  def initialize(organization)
    @organization = organization
  end

  def call
    notifier.ping message if Rails.env.production?
  end

  private

  def message
    <<~MESSAGE
      #{organization.name} is now a customer in Stripe.

      Create a subscription for them in Stripe to start billing.
    MESSAGE
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV.fetch('SLACK_WEBHOOK'), channel: '#sales', username: 'freddy'
    )
  end

  attr_reader :organization
end
