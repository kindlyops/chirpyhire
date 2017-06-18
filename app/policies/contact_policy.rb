class ContactPolicy < ApplicationPolicy
  def create?
    show?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(team: organization.teams)
    end
  end
end
