class ContactPolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    %i(screened)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
