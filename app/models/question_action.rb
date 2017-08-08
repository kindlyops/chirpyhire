class QuestionAction < BotAction
  belongs_to :question

  def question?
    true
  end

  def label
    'Question'
  end

  def select_label
    "Question #{question.rank}"
  end
end
