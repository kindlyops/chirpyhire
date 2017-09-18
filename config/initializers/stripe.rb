Rails.configuration.stripe = {
  publishable_key: ENV.fetch('STRIPE_PUBLISHABLE_KEY'),
  secret_key: ENV.fetch('STRIPE_SECRET_KEY')
}

Rails.configuration.stripe_event = {
  signing_secret: ENV.fetch('STRIPE_EVENT_SIGNING_SECRET')
}

StripeEvent.signing_secret = Rails.configuration.stripe_event[:signing_secret]
Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |events|
  events.subscribe 'invoice.', BillingEvent::Invoice.new
  events.subscribe 'customer.subscription.', BillingEvent::Subscription.new
end
