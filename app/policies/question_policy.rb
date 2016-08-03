class QuestionPolicy < ApplicationPolicy
  def edit?
    show?
  end

  def update?
    edit?
  end

  def permitted_attributes
    [:text, :status]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.survey.questions
    end
  end
end
