class TemplatePolicy < ApplicationPolicy
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
      scope.where(organization: account.organization)
    end
  end
end
