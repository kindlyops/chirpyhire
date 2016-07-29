class Maps::CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def show
    @map = Map.new
  end

  def index
    @map = Map.new
  end
end
