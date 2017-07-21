class ContactPolicy < ApplicationPolicy
  def create?
    show?
  end

  def update?
    show?
  end

  def permitted_attributes
    %i[contact_stage_id]
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
