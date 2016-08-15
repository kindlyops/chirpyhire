RSpec.configure do |config|
  config.before do
    ActiveJob::Base.queue_adapter = :test
  end

  config.before(type: :feature) do
    ActiveJob::Base.queue_adapter = :inline
  end
end
