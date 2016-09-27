class ApplicationJob < ActiveJob::Base
  include Rollbar::ActiveJob
  queue_as :default

  def self.backoff
    set(wait: 15.seconds)
  end
end
