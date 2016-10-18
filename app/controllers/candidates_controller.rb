class CandidatesController < ApplicationController
  decorates_assigned :candidates, :candidate
  DEFAULT_CREATED_IN_FILTER = 'Past Week'.freeze

  def show
    @candidate = authorized_candidate

    respond_to do |format|
      format.geojson do
        render json: GeoJson.build_sources([@candidate])
      end

      format.html
    end
  end

  def index
    respond_to do |format|
      format.geojson do
        @candidates = recent_candidates.includes(:candidate_features).decorate
        render json: GeoJson.build_sources(@candidates)
      end

      format.html do
        @zipcodes = zipcodes
        @candidates = filtered_and_paged_candidates
      end
    end
  end

  def edit
    @candidates = filtered_and_paged_candidates
    @candidate = authorized_candidate
    @zipcodes = zipcodes
    render :index
  end

  def update
    if authorized_candidate.update(permitted_attributes(Candidate))
      redirect_to candidates_url, notice: 'Nice! '\
      "#{authorized_candidate.handle} marked \
      as #{authorized_candidate.stage.name}"
    else
      redirect_to candidates_url, alert: "Oops! Couldn't change "\
      "the candidate's status"
    end
  end

  private

  def zipcodes
    zips = recent_candidates
           .map(&:zipcode)
           .uniq
           .compact
           .sort
    [CandidateFeature::ALL_ZIPCODES_CODE].concat(zips)
  end

  def filtered_and_paged_candidates
    recent_candidates.filter(filtering_params).page(params.fetch(:page, 1))
  end

  def authorized_candidate
    authorize Candidate.find(params[:id])
  end

  def recent_candidates
    policy_scope(Candidate).by_recency
  end

  def filtering_params
    { created_in: created_in, stage_name: stage_name, zipcode: zipcode }
  end

  def created_in
    cookied_query_param(
      :created_in,
      :candidate_created_in_filter,
      DEFAULT_CREATED_IN_FILTER
    )
  end

  def stage_name
    cookied_query_param(
      :stage_name,
      :candidate_stage_filter,
      current_organization.default_display_stage.name
    )
  end

  def zipcode
    cookied_query_param(
      :zipcode,
      :candidate_zipcode_filter,
      CandidateFeature::ALL_ZIPCODES_CODE
    )
  end

  def cookied_query_param(param_sym, cookie_sym, default)
    value = params[param_sym]
    if value.present?
      cookies[cookie_sym] = cookie(value)
    elsif cookies[cookie_sym].blank?
      cookies[cookie_sym] = cookie(default)
    end
    cookies[cookie_sym]
  end

  def cookie(value)
    { value: value }
  end
end
