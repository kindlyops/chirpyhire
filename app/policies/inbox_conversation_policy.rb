class InboxConversationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(inbox: account.inbox)
    end
  end
end
