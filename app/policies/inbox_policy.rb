class InboxPolicy < ApplicationPolicy
  def show?
    return if record.team.blank?

    organization.teams.where(id: record.team.id).exists?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(team: organization.teams)
    end
  end
end
