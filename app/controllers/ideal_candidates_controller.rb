class IdealCandidatesController < ApplicationController
  def show
    @candidate = authorized_candidate
    @suggestion = current_organization.suggestions.build
  end

  def update
    @candidate = authorized_candidate

    if @candidate.update(permitted_attributes(IdealCandidate))
      redirect_to candidate_path, notice: 'Nice! Ideal Candidate saved.'
    else
      render :show
    end
  end

  private

  def authorized_candidate
    authorize current_organization.ideal_candidate
  end
end
