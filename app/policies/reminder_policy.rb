class ReminderPolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def destroy?
    show?
  end

  def update?
    show?
  end

  def permitted_attributes
    %i[details event_at]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(contact: :organization)
        .where(contacts: { organization: organization })
    end
  end
end
