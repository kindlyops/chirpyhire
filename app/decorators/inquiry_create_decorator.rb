class InquiryCreateDecorator < Draper::Decorator
  delegate_all

  def subtitle
    "Asked #{question_name} question"
  end

  def color
    "complete-darker"
  end

  def icon_class
    "fa-question"
  end
end
