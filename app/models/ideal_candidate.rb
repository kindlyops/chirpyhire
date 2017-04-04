class IdealCandidate < ApplicationRecord
  belongs_to :organization
  has_many :zipcodes, class_name: 'IdealCandidateZipcode'
  accepts_nested_attributes_for :zipcodes,
                                reject_if: :all_blank, allow_destroy: true

  validates :zipcodes, presence: true

  def zipcode?(zipcode)
    zipcodes.pluck(:value).include?(zipcode)
  end
end
