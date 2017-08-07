class QuestionAction < BotAction
  belongs_to :question

  def question?
    true
  end

  def label
    'Question'
  end
end
