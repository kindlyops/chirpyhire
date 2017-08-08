class Engage::Auto::FollowUpsController < ApplicationController

  def edit
    @follow_up = authorize(bot.follow_ups.find(params[:id]))
  end

  def update
    @follow_up = authorize(bot.follow_ups.find(params[:id]))

    if @follow_up.update(permitted_attributes(@follow_up.type.constantize))
      redirect_to engage_auto_bot_path(bot), notice: 'Follow up updated!'
    else
      render :edit
    end
  end

  private

  def bot
    @bot ||= authorize(Bot.find(params[:bot_id]), :show?)
  end

end
