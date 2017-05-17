class MessagePolicy < ApplicationPolicy
  def create?
    # TODO: account is on contact team and contact is actively subscribed to the team
    recipient.actively_subscribed_to?(account.teams)
  end

  delegate :recipient, to: :record

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
