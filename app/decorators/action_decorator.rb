class ActionDecorator < Draper::Decorator
  delegate_all

  def actionable
    @actionable ||= object.actionable.decorate
  end

  delegate :title, :subtitle, :icon_class, to: :actionable
end
