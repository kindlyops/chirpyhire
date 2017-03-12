class RecruitingAdPolicy < ApplicationPolicy
  def update?
    scope.where(id: record.id).exists?
  end

  def show?
    record.new_record? || update?
  end

  def create?
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
