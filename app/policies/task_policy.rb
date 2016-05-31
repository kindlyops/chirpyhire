class TaskPolicy < ApplicationPolicy
  def update?
    show?
  end

  def edit?
    false
  end

  def permitted_attributes
    [:outstanding]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:user).where(users: { organization_id: account.organization.id })
    end
  end
end
