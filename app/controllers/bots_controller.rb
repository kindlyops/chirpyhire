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

  delegate :bots, to: :current_organization
end
