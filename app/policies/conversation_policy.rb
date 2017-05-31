class ConversationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:contact)
           .where(contacts: { team: account.teams })
    end
  end
end
