class AutomationPolicy < ApplicationPolicy
  attr_reader :account, :automation

  def initialize(account, automation)
    @account = account
    @automation = automation
  end

  def show?
    account.organization == automation.organization
  end

  def create?
    false
  end

  def update?
    false
  end

  def edit?
    false
  end

  def new?
    false
  end

  def destroy?
    false
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
