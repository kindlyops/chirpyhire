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
    [:enabled, :trigger_id, :action_id, :automation_id]
  end

  class Scope
    attr_reader :automation, :scope

    def initialize(automation, scope)
      @automation = automation
      @scope = scope
    end

    def resolve
      scope.where(automation: automation)
    end
  end
end
