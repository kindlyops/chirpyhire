class TemplatePolicy < ApplicationPolicy
  attr_reader :account, :template

  def initialize(account, template)
    @account = account
    @template = template
  end

  def preview?
    return unless account.present?
    account.organization == template.organization
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
