class NoticeDecorator < Draper::Decorator
  delegate_all

  def title
    "Notify candidate"
  end

  def subtitle
    "Gives the candidate helpful information."
  end

  def icon_class
    "fa-info"
  end
end
