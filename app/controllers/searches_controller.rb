class SearchesController < ApplicationController
  before_action :ensure_subscribed_candidates, only: :create
  before_action :ensure_questions, only: :create

  def show
    @search = searches.find(params[:id])
  end

  def index
    @searches = searches
  end

  def create
    if search.save
      search.start
      redirect_to search, notice: "Finding a caregiver now. Come back and check this page in a little while to see caregivers that would be a good fit."
    else
      render :new
    end
  end

  def new
    @search = SearchPresenter.new(current_account.searches.build, questions)
  end

  private

  def search
    @search ||= current_account.searches.build(search_questions: search_questions, candidates: subscribed_candidates)
  end

  def searches
    organization.searches
  end

  def search_questions
    question_ids.map.with_index(&method(:build_search_questions))
  end

  def build_search_questions(id, index)
    SearchQuestion.new(
      question_id: id,
      next_question_id: get_array_value(index+1),
      previous_question_id: get_array_value(index-1)
    )
  end

  def get_array_value(index)
    return if index < 0
    question_ids[index]
  end

  def questions
    organization.questions
  end

  def question_ids
    @question_ids ||= search_attributes[:question_ids]
  end

  def search_attributes
    @search_attributes ||= params[:search] || {}
  end

  def ensure_subscribed_candidates
    if subscribed_candidates.blank?
      redirect_to :back, alert: "There are no subscribed candidates!"
    end
  end

  def ensure_questions
    if question_ids.blank?
      redirect_to :back, alert: "No questions selected!"
    end
  end
end
