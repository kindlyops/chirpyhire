class ConversationPolicy < ApplicationPolicy
  def update?
    show?
  end

  def create?
    record.new_record?
  end

  def permitted_attributes
    %i[phone_number_id state closed_at]
      .push(contact_attributes: contact_attributes)
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
