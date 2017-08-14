class Engage::Auto::Questions::RemovesController < ApplicationController

  def show
    @question = authorize(bot.questions.find(params[:question_id]))
  end

  private

  def bot
    @bot ||= authorize(Bot.find(params[:bot_id]), :show?)
  end
end
