class SubscriptionPlanPolicy < ApplicationPolicy
  def new?
    true
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
    end
  end
end
