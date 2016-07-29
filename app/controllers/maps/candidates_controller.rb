class Maps::CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index

  def index
    @map = Map.new
  end
end
