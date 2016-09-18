class CandidatePolicy < ApplicationPolicy
  def edit?
    show?
  end

  def update?
    show?
  end

  def permitted_attributes
    [:stage_id]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.candidates
    end
  end
end
