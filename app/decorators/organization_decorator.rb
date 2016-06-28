class OrganizationDecorator < Draper::Decorator
  delegate_all

  def to
    object.name
  end
  alias :to_short :to

  def from
    to
  end
  alias :from_short :from

  def icon_class
    "fa-home"
  end
end
