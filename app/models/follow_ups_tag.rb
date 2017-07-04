class FollowUpsTag < ApplicationRecord
  belongs_to :follow_up
  belongs_to :tag
end
