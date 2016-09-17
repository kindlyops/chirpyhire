# frozen_string_literal: true
class MessagePolicy < ApplicationPolicy
  def create?
    return unless organization.present? && record.user.subscribed?

    organization == record.organization
  end

  def new?
    create?
  end

  def permitted_attributes
    [:body]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      organization.messages
    end
  end
end
