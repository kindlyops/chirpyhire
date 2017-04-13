class AccountDecorator < Draper::Decorator
  delegate_all

  include HeroPatternable
end
