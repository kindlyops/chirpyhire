class ChirpCreateDecorator < Draper::Decorator
  delegate_all

  def subtitle
    ""
  end

  def color
    "primary"
  end

  def icon_class
    "fa-commenting-o"
  end
end
