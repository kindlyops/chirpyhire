class BackPopulate::CandidateStageRefresher
  def self.refresh(candidate)
    if candidate.status == "Potential" && !(candidate.stage.present? && candidate.stage.potential?)
      candidate.stage = candidate.organization.potential_stage
      candidate.save!
    elsif candidate.status == "Bad Fit" && !(candidate.stage.present? && candidate.stage.bad_fit?) 
      candidate.stage = candidate.organization.bad_fit_stage
      candidate.save!
    elsif candidate.status == "Qualified" && !(candidate.stage.present? && candidate.stage.qualified?) 
      candidate.stage = candidate.organization.qualified_stage
      candidate.save!
    elsif candidate.status == "Hired" && !(candidate.stage.present? && candidate.stage.hired?) 
      candidate.stage = candidate.organization.hired_stage
      candidate.save!
    end
  end
end
