class CandidatesController < ApplicationController
  def index
    @candidates = candidates
  end

  private

  def candidates
    policy_scope Candidate
  end
end
