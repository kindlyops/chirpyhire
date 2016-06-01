class InquiryDecorator < Draper::Decorator
  delegate_all

  def subtitle
    "Asked #{question_name} of #{message.recipient.decorate.to}"
  end
end
