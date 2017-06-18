class ConversationPolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    %i[state]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(contact: organization.contacts)
    end
  end
end
