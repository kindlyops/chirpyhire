# frozen_string_literal: true
class Maps::CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized
  DEFAULT_FILTER = 'Qualified'

  def show
    determine_status

    @map = Map.new(current_organization)
  end

  def index
    determine_status

    @map = Map.new(current_organization)
  end

  private

  def determine_status
    status = params[:status]

    if status.present?
      cookies[:candidate_status_filter] = { value: status }
      status
    elsif cookies[:candidate_status_filter].present? && cookies[:candidate_status_filter] != 'Screened'
      cookies[:candidate_status_filter]
    else
      cookies[:candidate_status_filter] = { value: DEFAULT_FILTER }
      return DEFAULT_FILTER
    end
  end
end
