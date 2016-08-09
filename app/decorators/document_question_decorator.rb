class DocumentQuestionDecorator < Draper::Decorator
  delegate_all

  def label_placeholder
    "CNA License, TB Exam, etc."
  end

  def text_placeholder
    "Please send us a photo of your current CNA License."
  end
end
