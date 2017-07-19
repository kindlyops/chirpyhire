class PhoneNumberPolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    %i[forwarding_phone_number]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
