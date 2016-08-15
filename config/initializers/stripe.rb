if Rails.env.production?
  Stripe.api_key = ENV.fetch("STRIPE_SECRET_KEY")
else
  Stripe.api_key = ENV.fetch("STRIPE_SECRET_KEY", "DEV_TOKEN")
end
