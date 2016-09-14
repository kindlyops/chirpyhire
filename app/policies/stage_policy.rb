class StagePolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    show?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.stages
    end
  end
end