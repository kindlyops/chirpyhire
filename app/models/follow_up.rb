class FollowUp < ApplicationRecord
  belongs_to :question

  has_many :follow_ups_tags
  has_many :tags, through: :follow_ups_tags
end
