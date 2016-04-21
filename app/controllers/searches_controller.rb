class SearchesController < ApplicationController
  before_action :authenticate_account!

  before_action :ensure_leads, only: :create
  before_action :ensure_questions, only: :create

  def create
    search.start
  end

  def new
    @search = SearchPresenter.new(search: current_account.searches.build, questions: questions)
  end

  private

  def search
    @search ||= current_account.searches.create(search_questions: search_questions, leads: leads)
  end

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
    return if index < 0
    question_ids[index]
  end

  def questions
    organization.questions
  end

  def question_ids
    @question_ids ||= params[:search][:question_ids]
  end

  def ensure_leads
    if leads.blank?
      redirect_to :back, alert: "There are no leads!"
    end
  end

  def ensure_questions
    if question_ids.blank?
      redirect_to :back, alert: "No questions selected!"
    end
  end
end
