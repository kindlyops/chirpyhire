class ApplicationPolicy
  attr_reader :organization, :account, :record

  def initialize(account, record)
    unless account.present?
      raise Pundit::NotAuthorizedError, 'must be logged in'
    end

    @account = account
    @organization = account.organization
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(account, record.class)
  end

  class Scope
    attr_reader :account, :scope, :organization

    def initialize(account, scope)
      @account = account
      @organization = account.organization
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
