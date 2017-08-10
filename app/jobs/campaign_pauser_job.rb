class CampaignPauserJob < ApplicationJob
  def perform(campaign)
    Campaign::Pauser.call(campaign)
  end
end
