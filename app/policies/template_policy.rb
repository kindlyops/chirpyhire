class TemplatePolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    [:body, :name]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
