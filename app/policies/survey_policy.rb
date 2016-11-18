class SurveyPolicy < ApplicationPolicy
  def reorder?
    update?
  end

  def update?
    show?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
