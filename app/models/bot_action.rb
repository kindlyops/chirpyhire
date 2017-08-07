class BotAction < ApplicationRecord
  belongs_to :bot

  def next_question?
    false
  end

  def goal?
    false
  end

  def question?
    false
  end
end
