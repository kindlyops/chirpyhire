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

  def destroy
    @goal = authorize(bot.goals.find(params[:id]))
    destroy_goal
    redirect_to engage_auto_bot_path(bot), notice: 'Goal removed!'
  end

  private

  def destroy_goal
    migrate_follow_ups if params[:bot_action_id].present?
    @goal.destroy
    rerank_goals
  end

  def rerank_goals
    bot.reload.ranked_goals.each_with_index do |goal, i|
      goal.update(rank: i + 1)
    end
  end

  def migrate_follow_ups
    @goal.follow_ups.find_each do |follow_up|
      follow_up.update(action: new_action)
    end
  end

  def new_action
    @new_action ||= authorize(bot.actions.find(params[:bot_action_id]), :show?)
  end

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
