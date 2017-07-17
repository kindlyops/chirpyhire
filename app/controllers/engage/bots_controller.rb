class Engage::BotsController < ApplicationController
  def show
    @bot = authorize(bots.find(params[:id]))
  end

  delegate :bots, to: :current_organization
end
