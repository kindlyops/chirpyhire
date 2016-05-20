class Action < ActiveRecord::Base
  has_many :rules
  belongs_to :organization
  has_one :question
  has_one :notice

  def actionable
    question || notice
  end
end
