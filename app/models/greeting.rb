class Greeting < ApplicationRecord
  belongs_to :bot
  validates :body, presence: true
end
