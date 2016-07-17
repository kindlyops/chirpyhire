class CandidatePersonaActionable < Actionable
  has_one :candidate_persona, foreign_key: :actionable_id
  delegate :perform, to: :candidate_persona
end
