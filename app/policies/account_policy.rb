class AccountPolicy < ApplicationPolicy
  def update?
    show? && (same_account? || account.owner?)
  end

  def permitted_attributes
    attributes = %i[email bio phone_number name avatar daily_email
                    contact_waiting contact_ready]
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
