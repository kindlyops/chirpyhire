class Action < ActiveRecord::Base
  has_many :rules
  has_one :question
  has_one :notice

  def actionable
    question || notice
  end
end
