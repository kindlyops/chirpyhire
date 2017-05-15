class ContactDecorator < Draper::Decorator
  delegate_all
  decorates_association :person
  delegate :hero_pattern_classes, :availability, :certification,
           :cpr_first_aid, :experience, :handle, :live_in, :phone_number,
           :skin_test, :stats, :transportation, :candidacy_zipcode, to: :person

  def broad_query_params
    {
      zipcode: candidacy_zipcode.humanize_attribute,
      certification: [certification.query].compact
    }.delete_if { |_, v| v.blank? }
  end

  def near_query_params
    near_params.delete_if { |_, v| v.blank? }
  end

  def joined_at
    Contact::JoinedAt.new(object)
  end

  def last_active_at
    Contact::LastActiveAt.new(object)
  end

  private

  def near_params
    broad_query_params.merge(transportation: [transportation.query].compact,
                             availability: availabilities.compact,
                             experience: [experience.query].compact)
  end

  def availabilities
    availability.query_array.push(live_in.query)
  end
end
