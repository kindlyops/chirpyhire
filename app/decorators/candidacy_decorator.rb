class CandidacyDecorator < Draper::Decorator
  delegate_all

  def handle
    Candidacy::Handle.new(object)
  end

  def phone_number
    Candidacy::PhoneNumber.new(object)
  end

  def availability
    Candidacy::Availability.new(object)
  end

  def transportation
    Candidacy::Transportation.new(object)
  end

  def experience
    Candidacy::Experience.new(object)
  end

  def qualifications
    Candidacy::Qualifications.new(object)
  end

  def zipcode
    Candidacy::Zipcode.new(object)
  end

  def certification
    Candidacy::Certification.new(object)
  end

  def skin_test
    Candidacy::SkinTest.new(object)
  end

  def cpr_first_aid
    Candidacy::CprFirstAid.new(object)
  end

  def status
    Candidacy::Status.new(object, h.current_organization)
  end

  def subscribed
    Candidacy::Subscribed.new(object, h.current_organization)
  end

  def screened
    Candidacy::Screened.new(object, h.current_organization)
  end
end
