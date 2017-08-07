class NextQuestionAction < BotAction
  delegate :first_goal, to: :bot

  def next_step
    return first_goal if next_question.blank?
  end

  def trigger_next_question
    return trigger_first_goal if next_question.blank?
    next_question.trigger(message, campaign_contact)
  end

  def next_question
    bot.question_after(campaign_contact.question)
  end

  def trigger_first_goal
    first_goal.trigger(message, campaign_contact)
  end
end
