class Question < ApplicationRecord
  belongs_to :survey
  belongs_to :category
  has_many :inquiries
  enum status: [:active, :inactive]

  TYPES = %w(ChoiceQuestion AddressQuestion DocumentQuestion)
  validates_inclusion_of :type, in: TYPES
end
