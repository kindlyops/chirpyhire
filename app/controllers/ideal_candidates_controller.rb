class IdealCandidatesController < ApplicationController
  def show
    @suggestion = current_organization.suggestions.build
  end
end
