class CampaignPolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
