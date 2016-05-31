class TemplateDecorator < Draper::Decorator
  delegate_all

  def label
    name
  end

  def title
    "Notify candidate"
  end

  def subtitle
    "Gives the candidate helpful information."
  end

  def icon_class
    "fa-info"
  end

  def options
    organization.templates
  end

  def category
    object.class.to_s.humanize
  end
end
