class TaskPolicy < ApplicationPolicy
  def update?
    scope.where(id: record.id).exists?
  end

  def show?
    false
  end

  def edit?
    show?
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
