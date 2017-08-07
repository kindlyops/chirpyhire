class FollowUpDecorator < Draper::Decorator
  delegate_all
  delegate :next_question?, :goal?, :question?, to: :action
  delegate :goal, :question, to: :action, prefix: true

  def action_classes
    return 'FollowUp--action badge badge-next-question' if next_question?
    return 'FollowUp--action badge badge-question' if question?
    'FollowUp--action badge badge-goal'
  end

  def humanized_action
    return "#{action.label} #{action_goal.rank}" if goal?
    return "#{action.label} #{action_question.rank}" if question?

    action.label
  end

  def action
    super || bot.next_question_action
  end
end
