class RecruitingAdPolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    [:body]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
