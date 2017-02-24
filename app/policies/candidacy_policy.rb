class CandidacyPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.finished_survey
        .joins(person: :contacts)
        .where(people: { contacts: { organization_id: organization.id } })
    end
  end
end
