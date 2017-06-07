class ConversationPolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    %i(state)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:contact)
           .where(contacts: { team: account.teams })
    end
  end
end
