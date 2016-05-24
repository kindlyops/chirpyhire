class UserPolicy < ApplicationPolicy
  attr_reader :account, :user

  def initialize(account, user)
    @account = account
    @user = user
  end

  def create?
    false
  end

  def show?
    return unless account.present?
    account.organization == user.organization
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
    []
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
