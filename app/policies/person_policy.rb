class PersonPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:contacts)
           .where(contacts: { organization_id: organization.id })
    end
  end
end
