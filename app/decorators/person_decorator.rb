class PersonDecorator < Draper::Decorator
  delegate_all

  include HeroPatternable

  def handle
    Person::Handle.new(object)
  end

  def phone_number
    Person::PhoneNumber.new(object)
  end
end
