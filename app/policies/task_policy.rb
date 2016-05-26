class TaskPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(message: :user).where(users: { organization_id: account.organization.id })
    end
  end
end
