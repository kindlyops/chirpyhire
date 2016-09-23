class BackPopulate::CandidateStagePopulator
  def self.populate(candidate)
    return unless candidate.stage.blank?

    status_stage_map = {
      'Potential' => candidate.organization.potential_stage,
      'Bad Fit' => candidate.organization.bad_fit_stage,
      'Qualified' => candidate.organization.qualified_stage,
      'Hired' => candidate.organization.hired_stage,
    }

    status_stage_map.each do |status, stage|
      candidate.update!(stage: stage) if candidate.status == status
    end
  end
end
