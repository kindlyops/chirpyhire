class MessagePolicy < ApplicationPolicy
  attr_reader :account, :message

  def initialize(account, message)
    @account = account
    @message = message
  end

  def create?
    return unless account.present?
    account.organization == message.organization
  end

  def new?
    create?
  end

  def permitted_attributes
    [:body, :user_id]
  end

  class Scope
    attr_reader :account, :scope

    def initialize(account, scope)
      @account = account
      @scope = scope
    end

    def resolve
      scope.includes(:user).where(users: { organization_id: account.organization.id})
    end
  end
end
