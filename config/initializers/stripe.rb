if Rails.env.production?
  Stripe.api_key = ENV.fetch("STRIPE_SECRET_KEY")
  StripeEvent.authentication_secret = ENV.fetch("STRIPE_WEBHOOK_SECRET")
else
  Stripe.api_key = ENV.fetch("STRIPE_SECRET_KEY", "DEV_TOKEN")
  StripeEvent.authentication_secret = ENV.fetch("STRIPE_WEBHOOK_SECRET", "DEV_TOKEN")
end

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.' do |event|
    subscription = Subscription.find_by(stripe_id: event.data.object.id)
    RefreshSubscriptionJob.perform_later(subscription)
  end

  events.subscribe 'charge.failed' do |event|
    ChargesMailer.failed(event.data.object).deliver_later
  end

  events.subscribe 'customer.subscription.deleted' do |event|
    SubscriptionsMailer.deleted(event.data.object).deliver_later
  end

  events.subscribe 'charge.succeeded' do |event|
    ChargesMailer.succeeded(event.data.object).deliver_later
  end
end
