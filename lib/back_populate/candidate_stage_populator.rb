class BackPopulate::CandidateStagePopulator
  def self.populate(candidate)
    return unless candidate.stage.blank?

    case candidate.status
    when 'Potential'
      check_potential(candidate)
    when 'Bad Fit'
      check_bad_fit(candidate)
    when 'Qualified'
      check_qualified(candidate)
    when 'Hired'
      check_hired(candidate)
    end
  end

  def self.check_potential(candidate)
    candidate.update!(stage: candidate.organization.potential_stage)
  end

  def self.check_bad_fit(candidate)
    candidate.update!(stage: candidate.organization.bad_fit_stage)
  end

  def self.check_qualified(candidate)
    candidate.update!(stage: candidate.organization.qualified_stage)
  end

  def self.check_hired(candidate)
    candidate.update!(stage: candidate.organization.hired_stage)
  end
end
