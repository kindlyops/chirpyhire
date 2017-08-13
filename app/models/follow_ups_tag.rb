class FollowUpsTag < ApplicationRecord
  belongs_to :follow_up
  belongs_to :tag

  validates :follow_up, :tag, presence: true
  accepts_nested_attributes_for :tag, reject_if: :all_blank
end
