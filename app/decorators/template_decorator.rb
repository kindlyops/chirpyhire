class TemplateDecorator < Draper::Decorator
  delegate_all
  decorates_association :notice

  def icon_class
    notice.icon_class
  end

  def category
    notice.category
  end
end
