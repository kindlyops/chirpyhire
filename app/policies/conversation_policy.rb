class ConversationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(:contact)
        .where(account: account)
        .where(contacts: { team: account.teams })
    end
  end
end
