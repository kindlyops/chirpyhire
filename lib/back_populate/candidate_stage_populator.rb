class BackPopulate::CandidateStagePopulator
  def self.populate(candidate)
    case candidate.status
    when 'Potential'
      check_potential
    when 'Bad Fit'
      check_bad_fit
    when 'Qualified'
      check_qualified
    when 'Hired'
      check_hired
    end
  end

  def check_potential
    if !(candidate.stage.present? && candidate.stage.potential?)
      candidate.stage = candidate.organization.potential_stage
      candidate.save!
    end
  end

  def check_bad_fit
    if !(candidate.stage.present? && candidate.stage.bad_fit?)
      candidate.stage = candidate.organization.bad_fit_stage
      candidate.save!
    end
  end

  def check_qualified
    if !(candidate.stage.present? && candidate.stage.qualified?)
      candidate.stage = candidate.organization.qualified_stage
      candidate.save!
    end
  end

  def check_hired
    if !(candidate.stage.present? && candidate.stage.hired?)
      candidate.stage = candidate.organization.hired_stage
      candidate.save!
    end
  end
end
