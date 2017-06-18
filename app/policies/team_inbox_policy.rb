class TeamInboxPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(team: account.teams)
    end
  end
end
