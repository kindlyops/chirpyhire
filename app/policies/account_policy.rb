class AccountPolicy < ApplicationPolicy
  def show?
    record == account
  end

  def update?
    show?
  end

  def permitted_attributes
    %i(name email avatar)
  end
end
