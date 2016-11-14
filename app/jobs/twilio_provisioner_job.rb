class TwilioProvisionerJob < ApplicationJob
  def perform(organization)
    TwilioProvisioner.new(organization).provision
  end
end
