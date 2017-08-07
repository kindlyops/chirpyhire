class BotAction < ApplicationRecord
  belongs_to :bot

  def next_step; end
end
