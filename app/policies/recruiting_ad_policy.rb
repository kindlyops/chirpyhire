class RecruitingAdPolicy < ApplicationPolicy
  def update?
    show?
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def permitted_attributes
    [:body]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(team: account.teams)
    end
  end
end
