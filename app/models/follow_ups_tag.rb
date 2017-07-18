class FollowUpsTag < ApplicationRecord
  belongs_to :follow_up
  belongs_to :tag

  validates :follow_up, :tag, presence: true
end
