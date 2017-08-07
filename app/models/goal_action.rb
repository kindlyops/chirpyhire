class GoalAction < BotAction
  belongs_to :goal

  def goal?
    true
  end
end
