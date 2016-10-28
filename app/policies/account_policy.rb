class AccountPolicy < ApplicationPolicy
  def super_admin?
    record&.super_admin? || false
  end
end
