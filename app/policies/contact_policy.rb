class ContactPolicy < ApplicationPolicy
  def create?
    show?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if canceled?
        scope.where(organization: organization)
             .where('contacts.created_at < ?', organization.canceled_at)
      else
        scope.where(organization: organization)
      end
    end
  end
end
