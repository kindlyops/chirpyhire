class InboxConversationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(:inbox, :contact)
        .where(inboxes: { account: account })
        .where(contacts: { team: account.teams })
    end
  end
end
