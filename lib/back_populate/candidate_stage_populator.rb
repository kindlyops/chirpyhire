class BackPopulate::CandidateStagePopulator
  def self.populate(candidate)
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
    if !(candidate.stage.present? && candidate.stage.potential?)
      candidate.stage = candidate.organization.potential_stage
      candidate.save!
    end
  end

  def self.check_bad_fit(candidate)
    if !(candidate.stage.present? && candidate.stage.bad_fit?)
      candidate.stage = candidate.organization.bad_fit_stage
      candidate.save!
    end
  end

  def self.check_qualified(candidate)
    if !(candidate.stage.present? && candidate.stage.qualified?)
      candidate.stage = candidate.organization.qualified_stage
      candidate.save!
    end
  end

  def self.check_hired(candidate)
    if !(candidate.stage.present? && candidate.stage.hired?)
      candidate.stage = candidate.organization.hired_stage
      candidate.save!
    end
  end
end
