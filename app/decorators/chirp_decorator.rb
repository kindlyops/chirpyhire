class ChirpDecorator < Draper::Decorator
  delegate_all
  decorates_association :activities
  decorates_association :user

  def subtitle
    "#{user.from_short} has subscribed."
  end
end
