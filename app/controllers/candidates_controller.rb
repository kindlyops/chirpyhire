class CandidatesController < ApplicationController
  decorates_assigned :candidates

  def index
    @candidates = recent_candidates
  end

  private

  def recent_candidates
    @recent_candidates ||=
      policy_scope(Candidate).by_recency
                             .includes(:candidate_features, :user, :stage)
                             .references(:candidate_features, :user, :stage)
  end
end
