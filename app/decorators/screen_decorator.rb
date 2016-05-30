class ScreenDecorator < Draper::Decorator
  delegate_all

  def label
    ""
  end

  def title
    "Screened"
  end

  def subtitle
    "Candidate answers all screening questions"
  end

  def icon_class
    "fa-reply"
  end
end
