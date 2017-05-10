class PersonDecorator < Draper::Decorator
  delegate_all

  include HeroPatternable

  def broad_query_params
    {
      zipcode: candidacy_zipcode.query,
      certification: [certification.query].compact
    }.delete_if { |_k, v| v.blank? }
  end

  def near_query_params
    near_params.delete_if { |_k, v| v.blank? }
  end

  def near_params
    broad_query_params.merge(transportation: [transportation.query].compact,
                             availability: [availability.query].compact,
                             experience: [experience.query].compact)
  end

  def my_caregiver?
    object.contacts.where(organization: h.current_organization).exists?
  end

  def network?
    !my_caregiver?
  end

  def joined_at
    Person::JoinedAt.new(object)
  end

  def last_active_at
    broker_contact = Broker.first.broker_contacts.find_by(person: object)
    contact = h.current_organization.contacts.find_by(person: object)
    Contact::LastActiveAt.new(broker_contact || contact)
  end

  def stats
    Person::Stats.new(object)
  end

  def created_at
    Person::CreatedAt.new(object)
  end

  def handle
    Person::Handle.new(object)
  end

  def phone_number
    Person::PhoneNumber.new(object)
  end

  def availability
    Person::Availability.new(object)
  end

  def transportation
    Person::Transportation.new(object)
  end

  def experience
    Person::Experience.new(object)
  end

  def candidacy_zipcode
    Person::ZipCode.new(object)
  end

  def certification
    Person::Certification.new(object)
  end

  def skin_test
    Person::SkinTest.new(object)
  end

  def cpr_first_aid
    Person::CprFirstAid.new(object)
  end
end
