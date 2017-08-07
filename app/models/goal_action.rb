class GoalAction < BotAction
  belongs_to :goal

  def goal?
    true
  end

  def label
    'Goal'
  end
end
