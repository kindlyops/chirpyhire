class BotsController < ApplicationController
  def index
    @bots = policy_scope(Bot)

    respond_to do |format|
      format.json
    end
  end

  def show
    @bot = authorize(bots.find(params[:id]))

    respond_to do |format|
      format.json
    end
  end

  private

  def user_not_authorized(*)
    redirect_to engage_auto_campaigns_path, alert: active_campaign_alert
  end

  def active_campaign_alert
    "Pause #{@bot.name}'s active campaigns first before editing."
  end

  delegate :bots, to: :current_organization
end
