RSpec.configure do |config|
  config.before(type: :feature) do
    ActiveJob::Base.queue_adapter = :inline
  end
end
