class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  delegate :phone_number, to: :user, prefix: true

  def contents
    return "image" if images.present?
    "text"
  end
end
