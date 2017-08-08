class FollowUpDecorator < Draper::Decorator
  delegate_all
  delegate :next_question?, :goal?, :question?, to: :action
  delegate :goal, :question, to: :action, prefix: true

  def action_classes
    return 'badge badge-next-question' if next_question?
    return 'badge badge-question' if question?
    'badge badge-goal'
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
