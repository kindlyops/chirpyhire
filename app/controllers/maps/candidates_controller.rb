class Maps::CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def show
    set_stage_filter_cookie
    @map = Map.new(current_organization)
  end

  def index
    set_stage_filter_cookie
    @map = Map.new(current_organization)
  end

  private

  def set_stage_filter_cookie
    stage_id = params[:stage_id]

    if stage_id.present?
      cookies[:candidate_stage_filter] = { value: stage_id }
    elsif !cookies[:candidate_stage_filter].present?
      cookies[:candidate_stage_filter] = { value: current_organization.qualified_stage.id }
    end
  end
end
