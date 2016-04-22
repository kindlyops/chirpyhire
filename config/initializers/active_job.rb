if Rails.env.test?
  ActiveJob::Base.queue_adapter = :test
else
  ActiveJob::Base.queue_adapter = :sidekiq
end
