class QuestionPolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    %i[active]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:bot).where(bots: { organization: organization })
    end
  end
end
