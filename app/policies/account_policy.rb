class AccountPolicy < ApplicationPolicy
  def show?
    record == account
  end
end
