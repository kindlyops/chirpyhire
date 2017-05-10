class ContactDecorator < Draper::Decorator
  delegate_all
  decorates_association :person

  delegate :candidacy_zipcode, :stats, :created_at, :handle, :phone_number,
           :availability, :transportation, :experience, :certification,
           :skin_test, :cpr_first_aid, :broad_query_params, :near_query_params,
           :hero_pattern_classes, to: :person

  def last_active_at
    Contact::LastActiveAt.new(object)
  end
end
