class OrganizationDecorator < Draper::Decorator
  delegate_all

  include HeroPatternable
end
