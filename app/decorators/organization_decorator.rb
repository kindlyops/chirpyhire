class OrganizationDecorator < Draper::Decorator
  delegate_all

  def to
    object.name
  end

  def icon_class
    "fa-home"
  end
end
