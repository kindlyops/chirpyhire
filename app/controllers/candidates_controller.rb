class CandidatesController < ApplicationController
  decorates_assigned :candidates
  def index
    @candidates = scoped_candidates
  end

  private

  def scoped_candidates
    policy_scope(Candidate)
  end
end
