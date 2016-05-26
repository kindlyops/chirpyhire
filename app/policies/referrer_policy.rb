class ReferrerPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:user).where(users: { organization_id: account.organization.id })
    end
  end
end
