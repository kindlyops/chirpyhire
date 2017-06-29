class Goal < ApplicationRecord
  belongs_to :bot
  
  has_many :goals_tags
  has_many :tags, through: :goals_tags
end
