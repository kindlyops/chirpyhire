class Action < ActiveRecord::Base
  belongs_to :actionable, polymorphic: true
  belongs_to :trigger
end
