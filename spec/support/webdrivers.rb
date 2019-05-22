require 'webdrivers/chromedriver'

Webdrivers.configure do |config|
    config.cache_time = 86_400 # 24 hours is 24 * 60 * 60 seconds
end