class Engage::Auto::QuestionsController < ApplicationController
  def new
    @question = bot.questions.build
  end

  def create
    @question = new_question

    if @question.save
      redirect_to engage_auto_bot_path(bot), notice: 'Question created!'
    else
      render :new
    end
  end

  private

  def new_question
    authorize(bot.questions.build(permitted_attributes(Question)))
  end

  def bot
    @bot ||= authorize(Bot.find(params[:bot_id]), :show?)
  end
end
