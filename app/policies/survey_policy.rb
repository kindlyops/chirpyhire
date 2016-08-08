class SurveyPolicy < ApplicationPolicy
  def update?
    true
  end

  def permitted_attributes
    [questions_attributes: [:id, :priority]]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
