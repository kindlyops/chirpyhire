class CandidatePersona < ApplicationRecord
  belongs_to :organization
  belongs_to :actionable
  has_many :persona_features
  before_create :create_actionable

  def perform(user)
    ProfileAdvancer.call(user.candidate)
  end
end
