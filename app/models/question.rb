class Question < ApplicationRecord
  belongs_to :survey
  belongs_to :category
  enum status: [:active, :inactive]
end
