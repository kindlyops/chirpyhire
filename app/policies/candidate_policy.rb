class CandidatePolicy < ApplicationPolicy

  def initialize(account, candidate)
    @account = account
    @candidate = candidate
  end

  def index?
    true
  end

  def show?
    return unless account.present?
    account.organization == candidate.organization
  end

  def update?
    show?
  end

  def permitted_attributes
    [:status]
  end

  private

  attr_reader :account, :candidate

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
