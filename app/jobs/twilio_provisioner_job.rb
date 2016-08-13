class TwilioProvisionerJob < ApplicationJob
  queue_as :default

  def perform(organization)
    TwilioProvisioner.call(organization)
  end
end
