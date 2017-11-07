class CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: %i[index], if: :format_html?
  skip_after_action :verify_authorized, only: %i[search]
  before_action :prepare_predicates, only: %i[search]

  layout 'react', only: %i[index]
  PAGE_LIMIT = 24
  decorates_assigned :candidates

  def new
    @candidate = authorize(scope.build)
  end

  def create
    @candidate = authorize(scope.build(permitted_attributes(Contact)))

    if @candidate.valid?
      @candidate.person = Person.create
      @candidate.subscribed = true
      @candidate.save
      redirect_to candidates_segment_path(id: 'active')
    else
      render :new
    end
  end

  def search
    @q = scope.ransack(@predicates)

    respond_to do |format|
      format.json { @candidates = paginated(searched_candidates) }
      format.csv { @candidates = searched_candidates }
    end
  end

  def index
    redirect_to candidates_segment_path(id: 'active')
  end

  private

  def scope
    policy_scope(Contact)
  end

  def permitted_params
    params.permit(predicates: predicate_params)
  end

  def predicate_params
    [:type, :attribute, :value, :comparison, value: []]
  end

  def fetch_predicates
    permitted_params[:predicates].select { |p| p['value'].present? } || []
  end

  def prepare_predicates
    @predicates = Search::Predicates.call(fetch_predicates)
  end

  def searched_candidates
    @q.result(distinct: true).recently_replied
  end

  def paginated(scope)
    scope.page(page).per(PAGE_LIMIT)
  end

  def format_html?
    request.format == 'html'
  end

  def page
    params[:page].to_i || 1
  end
end
