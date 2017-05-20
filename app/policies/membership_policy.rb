class MembershipPolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    # %i(role)
    []
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:team).where(teams: { organization: organization })
    end
  end
end
