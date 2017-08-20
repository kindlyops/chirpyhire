class ManualMessagePolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def permitted_attributes
    [:title, :body, audience: audience]
  end

  def audience
    %i[zipcode_default_city_eq zipcode_state_abbreviation_eq
       zipcode_county_name_eq zipcode_zipcode_eq
       name_cont messages_count_eq].concat(
         [
           matches_all_tags: [],
           matches_all_manual_messages: [],
           contact_stage_id_in: []
         ]
       )
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
        .joins(account: :organization)
        .where(accounts: { organization: organization })
    end
  end
end
