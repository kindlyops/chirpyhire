class QuestionPolicy < ApplicationPolicy
  def edit?
    show?
  end

  def permitted_attributes
    []
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.survey.questions
    end
  end
end
