class QuestionPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    new?
  end

  def edit?
    show?
  end

  def update?
    edit?
  end

  def permitted_attributes
    [:text, :type, :status, :priority, :label]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.survey.questions
    end
  end
end
