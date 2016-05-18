class TriggerPolicy < ApplicationPolicy
  attr_reader :account, :trigger

  def initialize(account, trigger)
    @account = account
    @trigger = trigger
  end

  def create?
    return unless account.present?
    account.organization == trigger.organization
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
    [:enabled, :observable_type, :observable_id, :event]
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
