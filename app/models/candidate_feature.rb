class CandidateFeature < ApplicationRecord
  belongs_to :candidate
  belongs_to :category
  has_many :inquiries

  delegate :user, to: :candidate

  def child_class
    properties['child_class'] || "candidate_feature"
  end
end
