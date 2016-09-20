class CandidatesController < ApplicationController
  decorates_assigned :candidates, :candidate
  DEFAULT_STATUS_FILTER = 'Qualified'.freeze
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

  def filtering_params
    { status: status, created_in: created_in }
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

  def status
    status = params[:status]

    if status.present?
      cookies[:candidate_status_filter] = { value: status }
      status
    elsif cookies[:candidate_status_filter].present?
      cookies[:candidate_status_filter]
    else
      cookies[:candidate_status_filter] = { value: DEFAULT_STATUS_FILTER }
      return DEFAULT_STATUS_FILTER
    end
  end
end
