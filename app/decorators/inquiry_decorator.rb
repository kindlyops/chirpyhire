class InquiryDecorator < Draper::Decorator
  delegate_all

  def subtitle
    "Asked #{question_name} question"
  end
end
