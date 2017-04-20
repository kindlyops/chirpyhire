class ContactDecorator < Draper::Decorator
  delegate_all
  decorates_association :person
  delegate :hero_pattern_classes, to: :person

  def joined_at
    Caregiver::JoinedAt.new(object)
  end

  def last_active_at
    Caregiver::LastActiveAt.new(object)
  end

  def stats
    Caregiver::Stats.new(object)
  end

  def created_at
    Caregiver::CreatedAt.new(object)
  end

  def last_reply_at
    Caregiver::LastReplyAt.new(object)
  end

  def survey_progress
    Caregiver::SurveyProgress.new(object)
  end

  def temperature
    Caregiver::Temperature.new(object)
  end

  def handle
    Caregiver::Handle.new(object)
  end

  def phone_number
    Caregiver::PhoneNumber.new(object)
  end

  def availability
    Caregiver::Availability.new(object)
  end

  def transportation
    Caregiver::Transportation.new(object)
  end

  def experience
    Caregiver::Experience.new(object)
  end

  def qualifications
    Caregiver::Qualifications.new(object)
  end

  def candidacy_zipcode
    Caregiver::Zipcode.new(object)
  end

  def certification
    Caregiver::Certification.new(object)
  end

  def skin_test
    Caregiver::SkinTest.new(object)
  end

  def cpr_first_aid
    Caregiver::CprFirstAid.new(object)
  end

  def status
    Caregiver::Status.new(object)
  end

  def subscribed
    Caregiver::Subscribed.new(object)
  end

  def screened
    Caregiver::Screened.new(object)
  end
end
