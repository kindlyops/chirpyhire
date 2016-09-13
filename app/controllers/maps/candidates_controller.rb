class Maps::CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  DEFAULT_FILTER = Stage::QUALIFIED

  # TODO Is there a difference between these two methods? Can 
  # I get rid of one?
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
    stage = params[:stage]

    if stage.present?
      cookies[:candidate_stage_filter] = { value: stage }
    elsif !cookies[:candidate_stage_filter].present?
      cookies[:candidate_stage_filter] = { value: Stage.find_by(organization_id: current_organization.id, default_stage_mapping: DEFAULT_FILTER).id }
    end
  end
end
