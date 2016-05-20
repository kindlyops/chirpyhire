class Action < ActiveRecord::Base
  has_many :rules
  belongs_to :organization
  has_one :question
  has_one :notice

  delegate :template_name, :options, to: :actionable

  def actionable
    question || notice
  end
end
