class MapsController < ApplicationController
  decorates_assigned :candidate

  def show
    @candidate = authorized_candidate

    respond_to do |format|
      format.html{
        render "maps/show", layout: "map"
      }
    end
  end

  private

  def authorized_candidate
    authorize Candidate.find(params[:candidate_id])
  end
end
