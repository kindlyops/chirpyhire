class AccountPolicy < ApplicationPolicy
  def update?
    show? && (same_account? || account.owner?)
  end

  def permitted_attributes
    attributes = %i[email bio].push(person_attributes: %i[id name avatar])
    attributes.push(:role) if account.owner?
    attributes
  end

  private

  def same_account?
    record == account
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
