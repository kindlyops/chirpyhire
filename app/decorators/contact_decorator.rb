class ContactDecorator < Draper::Decorator
  delegate_all
  include HeroPatternable

  def joined_at
    Contact::JoinedAt.new(object)
  end

  def last_active_at
    Contact::LastActiveAt.new(object)
  end

  def phone_number
    Contact::PhoneNumberAttribute.new(object)
  end

  def candidacy_zipcode
    Contact::ZipCode.new(object)
  end
end
