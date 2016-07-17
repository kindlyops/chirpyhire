class CandidatePersona < ApplicationRecord
  belongs_to :organization
  has_many :persona_features
  belongs_to :actionable, class_name: "CandidatePersonaActionable", foreign_key: :actionable_id
  before_create :create_actionable

  def perform(user)
    ProfileAdvancer.call(user.candidate)
  end
end
