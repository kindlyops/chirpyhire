class ContactDecorator < Draper::Decorator
  delegate_all
  decorates_association :person
  delegate :hero_pattern_classes, to: :person

  def joined_at
    Contact::JoinedAt.new(object)
  end

  def last_active_at
    Contact::LastActiveAt.new(object)
  end

  def stats
    Contact::Stats.new(object)
  end

  def created_at
    Contact::CreatedAt.new(object)
  end

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

  def candidacy_zipcode
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
end
