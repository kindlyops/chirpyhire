class TagPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    record.new_record?
  end

  def permitted_attributes
    %i[name]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
