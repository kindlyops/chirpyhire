class DashboardPolicy < ApplicationPolicy
  def show?
    record.organization == organization
  end
end
