class PersonDecorator < Draper::Decorator
  delegate_all

  include HeroPatternable

  def joined_at
    Person::JoinedAt.new(object)
  end

  def last_active_at
    contact = h.current_organization.contacts.find_by(person: object)
    Contact::LastActiveAt.new(contact)
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
