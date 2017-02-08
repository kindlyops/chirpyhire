class Maps::CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def show
    set_stage_filter_cookie
    @candidate = authorize(Candidate.find(params[:id]))
    @map = Map.new(current_organization)
  end

  def index
    set_stage_filter_cookie
    @map = Map.new(current_organization)
  end

  private

  def set_stage_filter_cookie
    stage_name = Stage.find_by(id: params[:stage_id])&.name

    if stage_name.present?
      cookies[:candidate_stage_filter] = { value: stage_name }
    elsif cookies[:candidate_stage_filter].blank?
      cookies[:candidate_stage_filter] =
        { value: current_organization.default_display_stage.name }
    end
  end
end
