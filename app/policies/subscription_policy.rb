class SubscriptionPolicy < ApplicationPolicy
  def update?
    show?
  end

  def create?
    true
  end

  def permitted_attributes
    [:stripe_token, :plan_id, :quantity]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
