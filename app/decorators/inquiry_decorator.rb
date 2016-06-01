class InquiryDecorator < Draper::Decorator
  delegate_all

  def subtitle
    "Asked question of #{message.recipient.decorate.to}"
  end
end
