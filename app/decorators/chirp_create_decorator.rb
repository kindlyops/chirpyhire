class ChirpCreateDecorator < Draper::Decorator
  delegate_all
  decorates_association :message
  delegate :body, to: :message

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
