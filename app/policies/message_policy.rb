class MessagePolicy < ApplicationPolicy
  def create?
    recipient.actively_subscribed_to?(organization)
  end

  delegate :recipient, to: :record

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
