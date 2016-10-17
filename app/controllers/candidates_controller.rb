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
        @candidates = recent_candidates.decorate
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
    filtered_candidates.map(&:zipcode).uniq.compact.sort
  end

  def filtered_and_paged_candidates
    filtered_candidates.page(params.fetch(:page, 1))
  end

  def filtered_candidates
    recent_candidates.filter(filtering_params)
  end

  def authorized_candidate
    authorize Candidate.find(params[:id])
  end

  def recent_candidates
    policy_scope(Candidate).by_recency
  end

  def filtering_params
    { created_in: created_in, stage_name: stage_name }
  end

  def created_in
    created_in = params[:created_in]

    if created_in.present?
      cookies[:candidate_created_in_filter] = cookie(created_in)
    elsif cookies[:candidate_created_in_filter].blank?
      cookies[:candidate_created_in_filter] = cookie(DEFAULT_CREATED_IN_FILTER)
    end
    cookies[:candidate_created_in_filter]
  end

  def stage_name
    stage_name = determine_stage_name
    cookies[:candidate_stage_filter] = cookie(stage_name)
    stage_name
  end

  def determine_stage_name
    if params[:stage_name].present?
      params[:stage_name]
    elsif cookies[:candidate_stage_filter].present?
      cookies[:candidate_stage_filter]
    else
      current_organization.default_display_stage.name
    end
  end

  def cookie(value)
    { value: value }
  end
end
