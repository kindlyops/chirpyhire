class CandidatePersonasController < ApplicationController
  skip_after_action :verify_authorized, only: :show
  decorates_assigned :candidate_persona

  def show
    @candidate_persona = current_organization.candidate_persona
  end
end
