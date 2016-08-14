class Payola::SubscriptionPolicy < ApplicationPolicy
  def create?
    true
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(owner: organization)
    end
  end
end
