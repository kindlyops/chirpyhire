class TwilioProvisionerJob < ApplicationJob
  def perform(organization)
    TwilioProvisioner.call(organization)
  end
end
