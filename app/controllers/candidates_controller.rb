class CandidatesController < ApplicationController
  decorates_assigned :candidates, :candidate
  DEFAULT_FILTER = "Qualified"

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

    respond_to do |format|
      format.geojson do
        @candidates = filtered_candidates.with_addresses
        render json: GeoJson::Candidates.new(@candidates).call
      end

      format.html do
        @candidates = filtered_candidates.status(status).page(params.fetch(:page, 1))
      end
    end
  end

  def update
    if authorized_candidate.update(permitted_attributes(Candidate))
      redirect_to candidates_url, notice: "Nice! #{authorized_candidate.phone_number.phony_formatted} marked as #{authorized_candidate.status}"
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

  def status
    status = params[:status]

    if status.present?
      cookies[:candidate_status_filter] = { value: status }
      status
    elsif cookies[:candidate_status_filter].present? && cookies[:candidate_status_filter] != "Screened"
      cookies[:candidate_status_filter]
    else
      cookies[:candidate_status_filter] = { value: DEFAULT_FILTER }
      return DEFAULT_FILTER
    end
  end
end
