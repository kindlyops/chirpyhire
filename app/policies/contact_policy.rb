class ContactPolicy < ApplicationPolicy
  def create?
    show?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
