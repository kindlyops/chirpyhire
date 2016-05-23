class Action < ActiveRecord::Base
  has_many :rules
  belongs_to :organization
  has_one :question
  has_one :notice

  delegate :template_name, :actions, to: :actionable

  def self.for(action)
    joins(action.actionable.model_name.param_key.to_sym)
  end

  def actionable
    question || notice
  end
end
