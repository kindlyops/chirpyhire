class Rule < ActiveRecord::Base
  belongs_to :automation
  belongs_to :trigger
  belongs_to :action
  delegate :actionable, to: :action
  delegate :perform, to: :actionable
  delegate :organization, to: :automation

  validates :trigger, :automation, :action, presence: true
end
