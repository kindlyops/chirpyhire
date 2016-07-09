class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :activities

  def subtitle
    ""
  end
end
