class CandidatePersonaActionable < Actionable
  has_one :candidate_persona, foreign_key: :actionable_id, inverse_of: :actionable
  delegate :perform, to: :candidate_persona
end
