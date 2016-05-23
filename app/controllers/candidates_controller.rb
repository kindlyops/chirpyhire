class CandidatesController < ApplicationController
  decorates_assigned :candidates
  decorates_assigned :candidate

  def show
    @candidate = authorized_candidate
  end

  def index
    @candidates = scoped_candidates
  end

  private

  def authorized_candidate
    authorize Candidate.find(params[:id])
  end

  def scoped_candidates
    policy_scope(Candidate)
  end
end
