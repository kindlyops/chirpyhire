class Engage::Auto::GoalsController < ApplicationController
  def new
    @goal = bot.goals.build
  end

  def create
    @goal = new_goal

    if @goal.save
      redirect_to engage_auto_bot_path(bot), notice: 'Goal created!'
    else
      render :new
    end
  end

  private

  def new_goal
    authorize(bot.goals.build(permitted_attributes(Goal)))
  end

  def bot
    @bot ||= authorize(Bot.find(params[:bot_id]), :show?)
  end
end
