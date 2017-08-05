class MessagePolicy < ApplicationPolicy
  def create?
    !canceled? && subscribed? && conversation.open?
  end

  delegate :recipient, :conversation, to: :record
  delegate :subscribed?, to: :recipient

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(conversation: organization.conversations)
    end
  end
end
