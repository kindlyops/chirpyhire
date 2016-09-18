class SubscriptionPolicy < ApplicationPolicy
  def update?
    show?
  end

  def create?
    true
  end

  def destroy?
    show?
  end

  def permitted_attributes
    [:plan_id, :quantity]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
