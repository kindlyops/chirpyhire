class SegmentPolicy < ApplicationPolicy
  def create?
    record.new_record?
  end

  def permitted_attributes
    [:name, form: form]
  end

  def form
    [q: search_params]
  end

  def search_params
    %i[zipcode_default_city_eq zipcode_state_abbreviation_eq
       zipcode_county_name_eq zipcode_zipcode_eq
       last_reply_at_gt_days_ago last_reply_at_lt_days_ago
       last_reply_at_eq_days_ago created_at_gt_days_ago created_at_lt_days_ago
       created_at_eq_days_ago name_cont messages_count_eq].concat(array_params)
  end

  def array_params
    [
      matches_all_tags: [],
      matches_all_manual_messages: [],
      contact_stage_id_in: []
    ]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(account: account)
    end
  end
end
