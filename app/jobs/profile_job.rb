class ProfileJob < ActiveJob::Base
  queue_as :default

  def perform(user, profile)
    profile.advance(user)
  end
end
