class IdealCandidatePolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    [zip_codes_attributes: [:zip_code, :id, :_destroy]]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
