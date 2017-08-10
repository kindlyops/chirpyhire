class Engage::Auto::CampaignsController < ApplicationController
  def index
    @campaigns = policy_scope(Campaign)
  end

  def show
    @campaign = authorize(campaigns.find(params[:id]))
  end

  def update
    @campaign = authorize(campaigns.find(params[:id]))

    if @campaign.update(permitted_attributes(Campaign))
      handle_campaign_status_change
      redirect_to engage_auto_campaigns_path, notice: campaign_notice
    else
      render :show
    end
  end

  private

  def handle_campaign_status_change
    handle_activated_campaign if activated_bot_campaign?
    @campaign.update(last_paused_at: DateTime.current) if paused_campaign?
  end

  def handle_activated_campaign
    @campaign.update(last_active_at: DateTime.current)
    Campaign::Activator.call(@campaign)
  end

  def activated_bot_campaign?
    activated_campaign? && @campaign.bot.present?
  end

  def paused_campaign?
    status_changed? && @campaign.previous_changes['status'].last == 'paused'
  end

  def activated_campaign?
    status_changed? && @campaign.previous_changes['status'].last == 'active'
  end

  def status_changed?
    @campaign.previous_changes['status'].present?
  end

  def campaign_notice
    "#{@campaign.name} saved!"
  end

  delegate :campaigns, to: :current_organization
end
