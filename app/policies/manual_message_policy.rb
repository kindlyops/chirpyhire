class ManualMessagePolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def permitted_attributes
    [:title, :body, audience: audience]
  end

  def audience
    [predicates: predicates]
  end

  def predicates
    [:type, :attribute, :value, :comparison, value: []]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(account: :organization)
        .where(accounts: { organization: organization })
    end
  end
end
