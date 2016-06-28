class CandidateSubscribeDecorator < Draper::Decorator
  delegate_all

  def color
    "complete"
  end

  def body
    "#{user.from_short} is interested in opportunities at #{organization.name}."
  end

  def icon_class
    "fa-hand-paper-o"
  end

  def subtitle
    "#{user.from_short} has subscribed."
  end

  def attachments
    []
  end

  def user
    @user ||= object.user.decorate
  end
end
