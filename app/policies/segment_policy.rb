class SegmentPolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def permitted_attributes
    [:name, form: form]
  end

  def form
    %i[city state county zipcode name messages]
      .concat([tag: [], contact_stage: [], campaigns: []])
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(account: account)
    end
  end
end
