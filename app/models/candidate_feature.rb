class CandidateFeature < ApplicationRecord
  belongs_to :candidate
  belongs_to :category

  delegate :user, to: :candidate

  def self.address
    where("properties->>'child_class' = ?", "address")
  end

  def child_class
    properties['child_class'] || "candidate_feature"
  end
end
