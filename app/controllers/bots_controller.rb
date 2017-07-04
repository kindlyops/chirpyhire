class BotsController < ApplicationController
  def show
    @bot = authorize(bots.find(params[:id]))

    respond_to do |format|
      format.json
    end
  end

  delegate :bots, to: :current_organization
end
