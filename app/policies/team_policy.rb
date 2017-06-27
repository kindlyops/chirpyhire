class TeamPolicy < ApplicationPolicy
  def update?
    show? && account.on?(record)
  end

  def create?
    record.organization == organization
  end

  def new?
    record.new_record?
  end

  def permitted_attributes
    %i[name avatar recruiter_id description]
      .push(location_attributes: location_attributes)
  end

  def location_attributes
    %i[full_street_address
       latitude
       longitude
       city
       state
       state_code
       postal_code
       country
       country_code]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
