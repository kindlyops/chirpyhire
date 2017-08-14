class GoalDecorator < Draper::Decorator
  delegate_all

  def contact_stage_name
    contact_stage.name.humanize if contact_stage.present?
  end
end
