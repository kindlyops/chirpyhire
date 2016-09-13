class CandidatesController < ApplicationController
  decorates_assigned :candidates, :candidate
  DEFAULT_FILTER = Stage::QUALIFIED

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
    filtered_candidates = scoped_candidates.by_recency
    @organization = current_organization
    respond_to do |format|
      format.geojson do
        @candidates = filtered_candidates.with_addresses.decorate
        render json: GeoJson::Candidates.new(@candidates).call
      end

      format.html do
        @candidates = filtered_candidates.by_default_stage(stage).page(params.fetch(:page, 1))
      end
    end
  end

  def update
    # TODO JLW How does this work? What's being updated?
    if authorized_candidate.update(permitted_attributes(Candidate))
      redirect_to candidates_url, notice: "Nice! #{authorized_candidate.handle} marked as #{authorized_candidate.status}"
    else
      redirect_to candidates_url, alert: "Oops! Couldn't change the candidate's status"
    end
  end

  private

  def authorized_candidate
    authorize Candidate.find(params[:id])
  end

  def scoped_candidates
    policy_scope(Candidate)
  end

  def stage
    # TODO JLW Where does this get set? Also convert this to differentiate between default_stage_id and actual stage_id
    stage = params[:stage]

    if stage.present?
      cookies[:candidate_stage_filter] = { value: stage }
      stage
    elsif cookies[:candidate_stage_filter].present?
      cookies[:candidate_stage_filter]
    else
      cookies[:candidate_stage_filter] = { value: DEFAULT_FILTER }
      return DEFAULT_FILTER
    end
  end
end
