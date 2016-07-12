class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :activities
  delegate :name, :phone_number, to: :user, prefix: true

  def subtitle
    ""
  end

  def contents
    return "image" if images.present?
    "text"
  end
end
