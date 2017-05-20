class TeamPolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    %i(name avatar recruiter_id description)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
