class NotePolicy < ApplicationPolicy
  def update?
    scope.where(account: account, id: record.id).exists?
  end

  def show?
    record.new_record? || scope.where(id: record.id).exists?
  end

  def create?
    record.new_record?
  end

  def destroy?
    update?
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
