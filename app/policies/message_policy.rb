class MessagePolicy < ApplicationPolicy
  def create?
    !canceled? && subscribed?
  end

  delegate :recipient, :conversation, to: :record
  delegate :subscribed?, to: :recipient

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
