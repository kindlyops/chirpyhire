class InvoicePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(:subscription)
        .where(subscriptions: { organization: organization })
    end
  end
end
