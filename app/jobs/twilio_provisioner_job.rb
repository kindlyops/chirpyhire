# frozen_string_literal: true
class TwilioProvisionerJob < ApplicationJob
  def perform(organization)
    TwilioProvisioner.call(organization)
  end
end
