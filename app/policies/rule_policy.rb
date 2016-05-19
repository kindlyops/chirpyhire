class RulePolicy < ApplicationPolicy
  attr_reader :account, :rule

  def initialize(account, rule)
    @account = account
    @rule = rule
  end

  def create?
    return unless account.present?
    account.organization == rule.organization
  end

  def update?
    create?
  end

  def edit?
    update?
  end

  def new?
    create?
  end

  def destroy?
    create?
  end

  def permitted_attributes
    [:enabled, :trigger_id, :action_id]
  end

  class Scope
    attr_reader :account, :scope

    def initialize(account, scope)
      @account = account
      @scope = scope
    end

    def resolve
      scope.where(organization: account.organization)
    end
  end
end
