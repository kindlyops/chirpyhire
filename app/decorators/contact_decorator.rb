class ContactDecorator < Draper::Decorator
  delegate_all
  decorates_association :person
  delegate :hero_pattern_classes, :handle, :phone_number, to: :person

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

  def availability
    Contact::Availability.new(object)
  end

  def certification
    Contact::Certification.new(object)
  end

  def cpr_first_aid
    Contact::CprFirstAid.new(object)
  end

  def experience
    Contact::Experience.new(object)
  end

  def live_in
    Contact::LiveIn.new(object)
  end

  def skin_test
    Contact::SkinTest.new(object)
  end

  def stats
    Contact::Stats.new(object)
  end

  def transportation
    Contact::Transportation.new(object)
  end

  def candidacy_zipcode
    Contact::ZipCode.new(object)
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
