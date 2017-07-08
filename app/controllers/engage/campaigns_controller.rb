class Engage::CampaignsController < ApplicationController
  def show
    @campaign = authorize(campaigns.find(params[:id]))
  end

  delegate :campaigns, to: :current_organization
end
