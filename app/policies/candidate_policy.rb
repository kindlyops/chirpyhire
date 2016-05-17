class CandidatePolicy < ApplicationPolicy
  def index?
    true
  end

  class Scope
    attr_reader :account, :scope

    def initialize(account, scope)
      @account = account
      @scope = scope
    end

    def resolve
      scope.includes(:user).where(users: { organization_id: account.organization.id })
    end
  end
end
