class SegmentPolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def permitted_attributes
    [:name, form: form]
  end

  def form
    [predicates: predicates]
  end

  def predicates
    %i[type attribute value comparison]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(account: account)
    end
  end
end
