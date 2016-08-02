class Question < ApplicationRecord
  belongs_to :survey
  belongs_to :category
  has_many :inquiries
  enum status: [:active, :inactive]
end
