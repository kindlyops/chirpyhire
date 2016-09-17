# frozen_string_literal: true
class SurveyPolicy < ApplicationPolicy
  def update?
    show?
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
