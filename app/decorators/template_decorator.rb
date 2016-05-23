class TemplateDecorator < Draper::Decorator
  delegate_all
  decorates_association :question
  decorates_association :notice

  def icon_class
    (question || notice).icon_class
  end

  def category
    (question || notice).category
  end
end
