class BotAction < ApplicationRecord
  belongs_to :bot

  def next_question?
    false
  end

  alias goal? next_question?
  alias question? next_question?
end
