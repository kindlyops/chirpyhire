class InboxPolicy < ApplicationPolicy
  def show?
    record.account == account
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(account: account)
    end
  end
end