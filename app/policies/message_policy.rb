class MessagePolicy < ApplicationPolicy
  def create?
    person.actively_subscribed_to?(organization)
  end

  delegate :person, to: :record

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
