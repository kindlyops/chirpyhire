class GoalsTag < ApplicationRecord
  belongs_to :goal
  belongs_to :tag
end
