class QuestionsController < ApplicationController
  def update
    question.update(permitted_attributes(Question))
    rerank_follow_ups

    Broadcaster::Bot.broadcast(bot)
    head :ok
  end

  private

  def question
    @question ||= authorize(bot.questions.find(params[:id]))
  end

  def bot
    @bot ||= authorize(current_organization.bots.find(params[:bot_id]), :show?)
  end
end
