class CandidatePersona < ApplicationRecord
  belongs_to :organization
  has_many :persona_features

  def perform(user)
    ProfileAdvancer.call(user.candidate)
  end
end
