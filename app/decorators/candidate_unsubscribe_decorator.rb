class CandidateUnsubscribeDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def color
    "danger"
  end

  def body
    "#{user.from_short} is no longer interested in #{organization.name}."
  end

  def icon_class
    "fa-hand-paper-o"
  end

  def subtitle
    "#{user.from_short} has unsubscribed."
  end

  def attachments
    []
  end
end
