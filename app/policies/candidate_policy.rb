class CandidatePolicy < ApplicationPolicy
  def edit?
    show?
  end

  def update?
    show?
  end

  def permitted_attributes
    [:status]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:user).where(users: { organization_id: account.organization.id })
    end
  end
end
