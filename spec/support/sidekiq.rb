require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(type: :feature) do
    Sidekiq::Testing.inline!
  end
end
