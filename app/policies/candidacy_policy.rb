class CandidacyPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
      .joins(person: :subscribers)
      .where(people: { subscribers: { organization_id: organization.id }})
    end
  end
end
