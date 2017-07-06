class Engage::CampaignsController < ApplicationController
  layout 'react'

  def index
    @campaigns = policy_scope(Campaign)

    respond_to do |format|
      format.json
    end
  end

  def show
    @campaign = authorize(campaigns.find(params[:id]))

    respond_to do |format|
      format.json
      format.html { render html: '', layout: true }
    end
  end

  delegate :campaigns, to: :current_organization
end
