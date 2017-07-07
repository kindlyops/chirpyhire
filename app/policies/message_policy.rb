class MessagePolicy < ApplicationPolicy
  def create?
    !canceled? && actively_subscribed?
  end

  delegate :recipient, to: :record

  def actively_subscribed?
    recipient.actively_subscribed_to?(account.organization)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(conversation: organization.conversations)
    end
  end
end
