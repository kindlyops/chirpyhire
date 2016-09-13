class CandidatePolicy < ApplicationPolicy
  def edit?
    show?
  end

  def update?
    show?
  end

  #TODO JLW not sure if this works
  def permitted_attributes
    [:stage]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.candidates
    end
  end
end
