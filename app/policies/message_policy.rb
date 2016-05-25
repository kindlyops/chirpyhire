class MessagePolicy < ApplicationPolicy
  def create?
    return unless account.present?
    account.organization == record.organization
  end

  def new?
    create?
  end

  def permitted_attributes
    [:user_id]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.includes(:user).where(users: { organization_id: account.organization.id})
    end
  end
end
