class MembershipPolicy < ApplicationPolicy
  def update?
    show? && manager_on_team?
  end

  def destroy?
    show? && manager_on_team?
  end

  def create?
    manager_on_team?
  end

  def permitted_attributes
    %i[account_id role]
  end

  private

  def manager_on_team?
    account.manages?(record.team)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:team).where(teams: { organization: organization })
    end
  end
end
