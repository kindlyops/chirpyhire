class CampaignActivatorJob < ApplicationJob
  def perform(campaign)
    Campaign::Activator.call(campaign)
  end
end
