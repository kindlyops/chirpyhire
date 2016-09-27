class BackPopulate::CandidateStagePopulator
  def self.populate(candidate)
    return unless candidate.stage_id.blank?

    status_stage_map(candidate).each do |status, stage|
      candidate.update!(stage_id: stage.id) if candidate.status == status
    end
  end

  def self.status_stage_map(candidate)
    {
      'Potential' => candidate.organization.potential_stage,
      'Bad Fit' => candidate.organization.bad_fit_stage,
      'Qualified' => candidate.organization.qualified_stage,
      'Hired' => candidate.organization.hired_stage,
    }
  end
end
