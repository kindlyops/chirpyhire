class ConversationPolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    %i[state].push(contact_attributes: contact_attributes)
  end

  def contact_attributes
    %i[id contact_stage_id]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(contact: organization.contacts)
    end
  end
end
