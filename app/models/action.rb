class Action < ActiveRecord::Base
  belongs_to :actionable, polymorphic: true
  belongs_to :trigger

  delegate :perform, to: :actionable
  delegate :organization, to: :trigger
end
