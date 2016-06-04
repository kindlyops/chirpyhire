class ActivityPolicy < ApplicationPolicy
  def update?
    show?
  end

  def edit?
    false
  end

  def permitted_attributes
    [:outstanding]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins("JOIN users ON users.id=activities.owner_id AND activities.owner_type='User'")
      .where("users.organization_id=#{account.organization.id}")
    end
  end
end
