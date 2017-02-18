class PhoneNumberProvisionerJob < ApplicationJob
  def perform(organization)
    PhoneNumberProvisioner.new(organization).provision
  end
end
