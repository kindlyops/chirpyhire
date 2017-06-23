class SegmentPolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def permitted_attributes
    [:name, form: [:city, :state, :county, :zipcode, tag: []]]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(account: account)
    end
  end
end
