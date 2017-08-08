class NextQuestionAction < BotAction
  delegate :first_goal, to: :bot

  def next_question?
    true
  end

  def label
    'Next Question'
  end

  alias select_label label
end
