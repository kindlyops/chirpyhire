class BotAction < ApplicationRecord
  belongs_to :bot
  belongs_to :question, optional: true
  belongs_to :goal, optional: true

  enum category: {
    close: 0, question: 1, goal: 2
  }
end
