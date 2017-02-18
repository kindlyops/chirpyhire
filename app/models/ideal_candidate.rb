class IdealCandidate < ApplicationRecord
  belongs_to :organization
  has_many :zip_codes
  accepts_nested_attributes_for :zip_codes,
                                reject_if: :all_blank, allow_destroy: true

  validates :zip_codes, presence: true
end
