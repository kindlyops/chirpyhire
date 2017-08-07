class FollowUpDecorator < Draper::Decorator
  delegate_all

  def action_classes
    return 'FollowUp--action badge badge-next-question' if next_question?
    return 'FollowUp--action badge badge-question' if question?
    'FollowUp--action badge badge-goal'
  end

  def humanized_action
    return "#{action.titlecase} #{goal.rank}" if goal?
    return "#{action.titlecase} #{next_question.rank}" if question?

    action.titlecase
  end
end
