class CandidatesController < ApplicationController
  decorates_assigned :candidates, :candidate
  DEFAULT_CREATED_IN_FILTER = 'Past Week'.freeze

  def show
    @candidate = authorized_candidate

    respond_to do |format|
      format.geojson do
        render json: GeoJson::Candidates.new([@candidate]).call
      end

      format.html
    end
  end

  def index
    unfiltered_candidates = scoped_candidates.by_recency

    respond_to do |format|
      format.geojson do
        @candidates = unfiltered_candidates.with_addresses.decorate
        render json: GeoJson::Candidates.new(@candidates).call
      end

      format.html do
        @candidates = unfiltered_candidates.filter(filtering_params).page(params.fetch(:page, 1))
      end
    end
  end

  def update
    if authorized_candidate.update(permitted_attributes(Candidate))
      redirect_to candidates_url, notice: "Nice! #{authorized_candidate.handle} marked as #{authorized_candidate.stage.name}"
    else
      redirect_to candidates_url, alert: "Oops! Couldn't change the candidate's stage"
    end
  end

  private

  def authorized_candidate
    authorize Candidate.find(params[:id])
  end

  def scoped_candidates
    policy_scope(Candidate)
  end

  def filtering_params
    { created_in: created_in, stage_id: stage_id }
  end

  def created_in
    created_in = params[:created_in]

    if created_in.present?
      cookies[:candidate_created_in_filter] = { value: created_in }
      created_in
    elsif cookies[:candidate_created_in_filter].present?
      cookies[:candidate_created_in_filter]
    else
      cookies[:candidate_created_in_filter] = { value: DEFAULT_CREATED_IN_FILTER }
      return DEFAULT_CREATED_IN_FILTER
    end
  end

  def stage_id
    stage_id = params[:stage_id]

    if stage_id.present?
      cookies[:candidate_stage_filter] = { value: stage_id }
      stage_id
    elsif cookies[:candidate_stage_filter].present?
      cookies[:candidate_stage_filter]
    else
      default_stage_id = current_organization.default_display_stage.id
      cookies[:candidate_stage_filter] = { value: default_stage_id }
      return default_stage_id
    end
  end
end
