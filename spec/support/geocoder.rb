# frozen_string_literal: true
RSpec.configure do |config|
  config.before(:each) do
    Geocoder::Cache.new(
      Geocoder.config[:cache],
      Geocoder.config[:cache_prefix]
    ).expire(:all)
  end
end
