class ContactPolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def update?
    show?
  end

  def permitted_attributes
    %i[contact_stage_id name phone_number source email]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if canceled?
        scope.where(organization: organization)
             .where('contacts.created_at < ?', canceled_at)
      else
        scope.where(organization: organization)
      end
    end

    def canceled_at
      organization.internal_canceled_at
    end
  end
end
