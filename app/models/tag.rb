class Tag < ApplicationRecord
  belongs_to :organization

  has_many :taggings
  has_many :contacts, through: :taggings
end
