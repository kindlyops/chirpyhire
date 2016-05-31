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
    [:enabled, :trigger_id, :action_id, :action_type]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: account.organization)
    end
  end
end
