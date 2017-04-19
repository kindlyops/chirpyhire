class PersonDecorator < Draper::Decorator
  delegate_all

  include HeroPatternable
end
