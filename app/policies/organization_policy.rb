class OrganizationPolicy < ApplicationPolicy
  def show?
    record == organization
  end

  def update?
    show?
  end

  def permitted_attributes
    %i(name recruiter_id avatar)
  end
end
