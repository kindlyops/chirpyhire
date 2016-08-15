RSpecStripe.configure do |config|
  config.configure_rspec_metadata!
end

VCR.configure do |c|
  c.ignore_request do |request|
    URI(request.uri).host == "api.stripe.com"
  end
end
