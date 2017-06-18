class InboxPolicy < ApplicationPolicy
  def show?
    record.inboxable == account
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(inboxable: account)
    end
  end
end
