class Engage::Auto::BotsController < ApplicationController
  def show
    @bot = authorize(bots.find(params[:id]))
  end

  def update
    @bot = authorize(bots.find(params[:id]))

    if @bot.update(permitted_attributes(Bot))
      redirect_to engage_auto_bot_path(@bot), notice: bot_notice
    else
      render :show
    end
  end

  def clone
    @bot = authorize(bots.find(params[:bot_id]))

    @cloned_bot = BotFactory::Cloner.call(@bot)
    if @cloned_bot.valid?
      redirect_to engage_auto_bot_path(@cloned_bot), notice: clone_notice
    else
      render :show
    end
  end

  private

  def clone_notice
    "#{@bot.name} cloned successfully!"
  end

  def bot_notice
    "#{@bot.name} saved!"
  end

  delegate :bots, to: :current_organization
end
