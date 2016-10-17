class CandidateFeature < ApplicationRecord
  belongs_to :candidate

  delegate :user, to: :candidate

  ALL_ZIPCODES_CODE = 'All'

  def self.address
    where("properties->>'child_class' = ?", 'address')
  end

  def child_class
    properties['child_class'] || 'candidate_feature'
  end
end
