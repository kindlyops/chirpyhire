class Rule < ActiveRecord::Base
  belongs_to :organization
  belongs_to :trigger
  belongs_to :action
  delegate :actionable, to: :action
  delegate :perform, to: :actionable

  validates :trigger, :organization, :action, presence: true
end
