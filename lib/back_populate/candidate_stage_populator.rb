class BackPopulate::CandidateStagePopulator
  def self.populate(candidate)
    unless candidate.stage.present? 
      
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
      candidate.stage = candidate.organization.potential_stage
      candidate.save!
  end

  def self.check_bad_fit(candidate)
      candidate.stage = candidate.organization.bad_fit_stage
      candidate.save!
  end

  def self.check_qualified(candidate)
      candidate.stage = candidate.organization.qualified_stage
      candidate.save!
  end

  def self.check_hired(candidate)
      candidate.stage = candidate.organization.hired_stage
      candidate.save!
  end
end
