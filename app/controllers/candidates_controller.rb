class CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped
  def index
  end
end
