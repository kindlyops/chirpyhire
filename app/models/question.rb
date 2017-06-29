class Question < ApplicationRecord
  belongs_to :bot

  has_many :follow_ups
end
