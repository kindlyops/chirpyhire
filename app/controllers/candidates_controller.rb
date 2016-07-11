class CandidatesController < ApplicationController
  decorates_assigned :candidates, :candidate

  def show
    @candidate = authorized_candidate
  end

  def index
    @candidates = scoped_candidates.filter(filter_params).page(params.fetch(:page, 1))
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

  def filter_params
    status = params.slice(:status)
    return { status: "Potential" } unless status.present?
    status
  end
end
