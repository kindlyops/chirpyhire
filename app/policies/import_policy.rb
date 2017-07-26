class ImportPolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def edit?
    show?
  end

  def permitted_attributes
    %i[file]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:account).where(accounts: { organization: organization })
    end
  end
end
