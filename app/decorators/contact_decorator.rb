class ContactDecorator < Draper::Decorator
  delegate_all

  def handle
    Contact::Handle.new(object)
  end

  def phone_number
    Contact::PhoneNumber.new(object)
  end

  def availability
    Contact::Availability.new(object)
  end

  def transportation
    Contact::Transportation.new(object)
  end

  def experience
    Contact::Experience.new(object)
  end

  def qualifications
    Contact::Qualifications.new(object)
  end

  def zipcode
    Contact::Zipcode.new(object)
  end

  def certification
    Contact::Certification.new(object)
  end

  def skin_test
    Contact::SkinTest.new(object)
  end

  def cpr_first_aid
    Contact::CprFirstAid.new(object)
  end

  def status
    Contact::Status.new(object)
  end

  def subscribed
    Contact::Subscribed.new(object)
  end

  def screened
    Contact::Screened.new(object)
  end
end
