class StagePolicy < ApplicationPolicy
  def create?
    true
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.stages
    end
  end
end