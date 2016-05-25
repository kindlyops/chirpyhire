class TemplatePolicy < ApplicationPolicy
  def show?
    false
  end

  def preview?
    return unless account.present?
    account.organization == record.organization
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: account.organization)
    end
  end
end
