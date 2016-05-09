class Action < ActiveRecord::Base
  belongs_to :actionable, polymorphic: true
end
