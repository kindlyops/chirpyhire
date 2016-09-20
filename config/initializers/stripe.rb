if Rails.env.production?
  Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')
  StripeEvent.authentication_secret = ENV.fetch('STRIPE_WEBHOOK_SECRET')
else
  Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY', 'DEV_TOKEN')
  StripeEvent.authentication_secret = ENV.fetch('STRIPE_WEBHOOK_SECRET', 'DEV_TOKEN')
end

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.' do |event|
    Payment::Job::RefreshSubscription.perform_later(event.data.object.id)
  end

  events.subscribe 'customer.subscription.deleted' do |event|
    subscription = { id: event.data.object.id }
    Payment::Mailer::Subscriptions.deleted(subscription).deliver_later
  end

  events.subscribe 'charge.failed' do |event|
    charge = {
      customer: event.data.object.customer,
      amount: event.data.object.amount,
      failure_code: event.data.object.failure_code,
      failure_message: event.data.object.failure_message
    }
    Payment::Mailer::Charges.failed(charge).deliver_later
  end

  events.subscribe 'charge.succeeded' do |event|
    charge = { customer: event.data.object.customer, amount: event.data.object.amount }
    Payment::Mailer::Charges.succeeded(charge).deliver_later
  end
end
