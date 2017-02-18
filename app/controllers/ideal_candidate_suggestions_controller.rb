class IdealCandidateSuggestionsController < ApplicationController
  def create
    @suggestion = authorize new_suggestion

    if @suggestion.save
      redirect_to candidate_path, notice: 'Thank you for the suggestion!'
    else
      render 'ideal_candidates/show'
    end
  end

  private

  def new_suggestion
    suggestions.build(permitted_attributes(IdealCandidateSuggestion))
  end

  delegate :suggestions, to: :current_organization
end
