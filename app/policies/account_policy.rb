class AccountPolicy < ApplicationPolicy
  def show?
    record == account
  end

  def update?
    show?
  end

  def permitted_attributes
    %i(email).push(person_attributes: %i(name avatar))
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
