class Engage::Auto::Goals::RemovesController < ApplicationController
  def show
    @goal = authorize(bot.goals.find(params[:goal_id]))
  end

  private

  def bot
    @bot ||= authorize(Bot.find(params[:bot_id]), :show?)
  end
end
