module Stripe
  def prepare_signature(secret, payload)
    @env ||= {}
    @env['HTTP_STRIPE_SIGNATURE'] = generate_signature(secret, payload)
  end

  def generate_signature(secret, payload)
    timestamp = Time.now.to_i
    signature = Stripe::Webhook::Signature.send(:compute_signature, "#{timestamp}.#{payload}", secret)
    "t=#{timestamp},v1=#{signature}"
  end
end

RSpec.configure do |config|
  config.include Stripe, type: :request
end
