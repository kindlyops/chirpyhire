class CandidatesController < ApplicationController
  def index
    @candidates = candidates
  end

  private

  def candidates
    organization.candidates
  end
end
