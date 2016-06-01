class CandidatesController < ApplicationController
  decorates_assigned :candidates, :candidate

  def show
    @candidate = authorized_candidate
  end

  def index
    @candidates = scoped_candidates
  end

  def update
    if authorized_candidate.update(permitted_attributes(Candidate))
      @candidate = authorized_candidate

      respond_to do |format|
        format.js {
          render :update
        }
      end
    end
  end

  private

  def authorized_candidate
    authorize Candidate.find(params[:id])
  end

  def scoped_candidates
    policy_scope(Candidate)
  end
end
