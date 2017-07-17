class Engage::BotsController < ApplicationController
  def show
    @bot = authorize(bots.find(params[:id]))
  end

  def update
    @bot = authorize(bots.find(params[:id]))

    if @bot.update(permitted_attributes(Bot))
      redirect_to engage_bot_path(@bot), notice: bot_notice
    else
      render :show
    end
  end

  private

  def bot_notice
    "#{@bot.name} Recruitbot saved!"
  end

  delegate :bots, to: :current_organization
end
