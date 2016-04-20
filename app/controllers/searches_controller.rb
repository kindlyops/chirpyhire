class SearchesController < ApplicationController
  before_action :authenticate_account!

  def create
    current_account.searches.build do |search|
      search.search_questions << search_questions
      search.leads << leads
      search.save!

      search.inquire
    end
  end

  private

  def search_questions
    question_ids.map.with_index do |id, index|
      SearchQuestion.new(
        question_id: id,
        next_question_id: get_array_value(index+1),
        previous_question_id: get_array_value(index-1)
      )
    end
  end

  def get_array_value(index)
    return question_ids[index] unless index < 0
    nil
  end

  def question_ids
    @question_ids ||= params[:search][:question_ids]
  end
end
