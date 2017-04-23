class NotePolicy < ApplicationPolicy
  def update?
    scope.where(account: account, id: record.id).exists?
  end

  def show?
    record.new_record? || update?
  end

  def create?
    show?
  end

  def destroy?
    show?
  end

  def permitted_attributes
    [:body]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:account).where(accounts: { organization: organization })
    end
  end
end
