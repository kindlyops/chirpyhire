class CandidatePersonaActionable < Actionable
  has_one :candidate_persona
  delegate :perform, to: :candidate_persona
end
