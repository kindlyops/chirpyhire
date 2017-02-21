class CandidaciesController < ApplicationController
  decorates_assigned :candidacies

  def index
    @candidacies = policy_scope(Candidacy)

    respond_to do |format|
      format.json
    end
  end
end
