class RulePolicy < ApplicationPolicy
  def create?
    return unless account.present?
    account.organization == record.organization
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def new?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    [:enabled, :trigger_id, :action_id, :automation_id]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.includes(:automation).where(automations: { organization_id: account.organization.id })
    end
  end
end
