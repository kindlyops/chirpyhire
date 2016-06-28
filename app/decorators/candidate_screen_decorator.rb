class CandidateScreenDecorator < Draper::Decorator
  delegate_all

  def color
    "complete"
  end

  def body
    "Woohoo! #{user.from_short}'s profile is completed. Please review at your convenience."
  end

  def icon_class
    "fa-star"
  end

  def subtitle
    "#{user.from_short} has answered all screening questions"
  end

  def attachments
    []
  end

  def user
    @user ||= object.user.decorate
  end
end
