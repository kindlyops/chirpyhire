class CandidatesController < ApplicationController
  decorates_assigned :candidates, :candidate

  def show
    @candidate = authorized_candidate
  end

  def index
    @candidates = scoped_candidates.filter(filter_params).page(params.fetch(:page, 1))
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

  def filter_params
    status = params.slice(:status)
    return { status: "Potential" } unless status.present?
    status
  end
end
