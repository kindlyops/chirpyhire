class AccountPolicy < ApplicationPolicy
  def show?
    record == account
  end

  def update?
    show?
  end

  def permitted_attributes
    %i(name email avatar)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
