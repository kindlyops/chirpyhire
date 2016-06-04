class CandidateProfile < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :ideal_profile
  has_many :candidate_profile_features

  enum status: [:sleeping, :running, :finished]
end
