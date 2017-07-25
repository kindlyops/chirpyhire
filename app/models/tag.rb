class Tag < ApplicationRecord
  belongs_to :organization

  has_many :taggings
  has_many :contacts, through: :taggings

  has_many :follow_ups_tags
  has_many :follow_ups, through: :follow_ups_tags
end
