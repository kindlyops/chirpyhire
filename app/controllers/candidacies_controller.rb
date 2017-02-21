class CandidaciesController < ApplicationController

  def index
    @candidacies = policy_scope(Candidacy)

    respond_to do |format|
      format.json
    end
  end
end
