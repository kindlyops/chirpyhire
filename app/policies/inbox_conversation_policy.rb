class InboxConversationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(conversation: :contact)
           .where(conversations: { contacts: { team: account.teams } })
    end
  end
end
