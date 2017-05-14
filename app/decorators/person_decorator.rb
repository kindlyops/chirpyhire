class PersonDecorator < Draper::Decorator
  delegate_all

  include HeroPatternable

  def availability
    Person::Availability.new(object)
  end

  def certification
    Person::Certification.new(object)
  end

  def cpr_first_aid
    Person::CprFirstAid.new(object)
  end

  def experience
    Person::Experience.new(object)
  end

  def handle
    Person::Handle.new(object)
  end

  def live_in
    Person::LiveIn.new(object)
  end

  def phone_number
    Person::PhoneNumber.new(object)
  end

  def skin_test
    Person::SkinTest.new(object)
  end

  def stats
    Person::Stats.new(object)
  end

  def transportation
    Person::Transportation.new(object)
  end

  def candidacy_zipcode
    Person::ZipCode.new(object)
  end
end
