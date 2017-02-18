class IdealCandidatePolicy < ApplicationPolicy
  def update?
    show?
  end

  def permitted_attributes
    [zipcodes_attributes: [:zipcode, :id, :_destroy]]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
