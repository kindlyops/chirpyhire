class OrganizationDecorator < Draper::Decorator
  delegate_all

  def phone_number
    object.phone_number || ""
  end
end
