class ConversationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:account).where(accounts: { organization: organization })
    end
  end
end
