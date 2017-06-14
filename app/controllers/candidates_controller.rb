class CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: %i[index]
  layout 'candidates', only: %i[index]

  def index
    render html: '', layout: true
  end
end
