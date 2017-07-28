class ColumnMappingPolicy < ApplicationPolicy
  def edit?
    show?
  end

  def update?
    show?
  end

  def permitted_attributes
    %i[column_number]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:import).where(imports: { account_id: account.id })
    end
  end
end
