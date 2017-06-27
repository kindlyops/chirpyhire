class MembershipPolicy < ApplicationPolicy
  def update?
    show?
  end

  def destroy?
    show?
  end

  def create?
    organization.teams.where(id: record.team.id).exists?
  end

  def permitted_attributes
    %i[account_id]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:team).where(teams: { organization: organization })
    end
  end
end
