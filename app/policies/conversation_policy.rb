class ConversationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:contacts).where(contacts: { team: account.teams })
    end
  end
end
