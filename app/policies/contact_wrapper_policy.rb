class ContactWrapperPolicy < ApplicationPolicy
  def scope
    Contact
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
