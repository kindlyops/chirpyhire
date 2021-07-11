class Engage::Auto::BotsController < ApplicationController
  def index
    @bots = policy_scope(Bot)
  end

  def show
    @bot = authorize(bots.find(params[:id]))
  end

  def update
    @bot = authorize(bots.find(params[:id]))

    if @bot.update(permitted_attributes(Bot))
      rerank_question_follow_ups
      redirect_to engage_auto_bot_path(@bot), notice: bot_notice
    else
      render :show
    end
  end

  def new
    @bot = authorize(current_organization.bots.build(account: current_account))
    @bot.build_greeting
    question = @bot.questions.build
    question.follow_ups.build
    @bot.goals.build
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

  def rerank_question_follow_ups
    @bot.reload.questions.each(&method(:rerank_follow_ups))
  end

  def rerank_follow_ups(question)
    question.ranked_follow_ups.each.with_index(1) do |follow_up, i|
      next if follow_up.rank == i
      follow_up.update(rank: i)
    end
  end

  def clone_notice
    "#{@bot.name} cloned successfully!"
  end

  def bot_notice
    "#{@bot.name} saved!"
  end

  delegate :bots, to: :current_organization
end
