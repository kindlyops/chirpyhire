class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :activities

  delegate :from, to: :user

  def subtitle
    ""
  end
end
