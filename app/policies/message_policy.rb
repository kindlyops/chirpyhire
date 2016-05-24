class MessagePolicy < ApplicationPolicy
  attr_reader :account, :message

  def initialize(account, message)
    @account = account
    @message = message
  end

  def create?
    return unless account.present?
    account.organization == message.organization
  end

  def show?
    false
  end

  def update?
    false
  end

  def edit?
    false
  end

  def new?
    create?
  end

  def destroy?
    false
  end

  def permitted_attributes
    [:body, :user_id]
  end

  class Scope
    attr_reader :recipient, :scope

    def initialize(recipient, scope)
      @recipient = recipient
      @scope = scope
    end

    def resolve
      recipient.messages
    end
  end
end
