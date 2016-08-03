class QuestionsController < ApplicationController
  def edit
    @question = authorize(Question.find(params[:id]))
  end
end
