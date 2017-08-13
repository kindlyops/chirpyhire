class Engage::Auto::GoalsController < ApplicationController
  def new
    @goal = bot.goals.build
  end

  def create
    @goal = new_goal

    if @goal.save
      create_action
      redirect_to engage_auto_bot_path(bot), notice: 'Goal created!'
    else
      render :new
    end
  end

  private

  def create_action
    bot.actions.create(type: 'GoalAction', goal_id: @goal.id)
  end

  def new_goal
    authorize(bot.goals.build(permitted_attributes(Goal)))
  end

  def bot
    @bot ||= authorize(Bot.find(params[:bot_id]), :show?)
  end
end
