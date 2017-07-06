class Engage::CampaignsController < ApplicationController
  layout 'react'

  def new
    @campaign = authorize(current_organization.campaigns.build)

    respond_to do |format|
      format.html { render html: '', layout: true }
    end
  end

  def show
    @campaign = authorize(Campaign.find(params[:id]))

    respond_to do |format|
      format.json
      format.html { render html: '', layout: true }
    end
  end
end
