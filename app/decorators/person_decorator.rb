class PersonDecorator < Draper::Decorator
  delegate_all

  include HeroPatternable

  def handle
    Person::Handle.new(object)
  end

  def phone_number
    Person::PhoneNumberAttribute.new(object)
  end
end
