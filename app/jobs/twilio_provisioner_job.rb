class TwilioProvisionerJob < ApplicationJob
  queue_as :default

  def perform(organization)
  end
end
