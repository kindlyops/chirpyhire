class TeamDecorator < Draper::Decorator
  delegate_all

  include HeroPatternable
end
