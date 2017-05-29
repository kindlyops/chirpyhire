class IdealCandidateSuggestionPolicy < ApplicationPolicy
  def create?
    true
  end

  def permitted_attributes
    %i[value]
  end
end
