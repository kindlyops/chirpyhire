class OrganizationPolicy < ApplicationPolicy
  def show?
    record == organization
  end

  def update?
    show?
  end

  def permitted_attributes
    attributes = %i[name avatar email description url]
    attributes.push(:billing_email) if account.owner?
    attributes
  end
end
