# frozen_string_literal: true
class ApplicationPolicy
  attr_reader :organization, :record

  def initialize(organization, record)
    raise Pundit::NotAuthorizedError, 'must be logged in' unless organization.present?

    @organization = organization
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
    Pundit.policy_scope!(organization, record.class)
  end

  def user
    organization
  end

  class Scope
    attr_reader :organization, :scope

    def initialize(organization, scope)
      @organization = organization
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
