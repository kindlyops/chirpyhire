class CandidatesController < ApplicationController
  decorates_assigned :candidates, :candidate

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
        @candidates = filtered_candidates.where(stage_id: stage_id).page(params.fetch(:page, 1))
      end
    end
  end

  def update
    if authorized_candidate.update(permitted_attributes(Candidate))
      redirect_to candidates_url, notice: "Nice! #{authorized_candidate.handle} marked as #{authorized_candidate.stage.name}"
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

  def stage_id
    stage_id = params[:stage_id]

    if stage_id.present?
      cookies[:candidate_stage_filter] = { value: stage_id }
      stage_id
    elsif cookies[:candidate_stage_filter].present?
      cookies[:candidate_stage_filter]
    else
      default_stage_id = current_organization.qualified_stage.id
      cookies[:candidate_stage_filter] = { value: default_stage_id }
      return default_stage_id
    end
  end
end
