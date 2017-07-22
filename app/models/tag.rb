class Tag < ApplicationRecord
  belongs_to :organization

  has_many :taggings
  has_many :contacts, through: :taggings

  has_many :follow_ups_tags
  has_many :follow_ups, through: :follow_ups_tags

  has_many :goals_tags
  has_many :goals, through: :goals_tags

  def self.screened
    where(name: 'Screened')
  end

  def self.without_stages
    where.not(name: ContactStage.defaults)
  end
end
