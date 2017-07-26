class ImportPolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:account).where(accounts: { organization: organization })
    end
  end
end
