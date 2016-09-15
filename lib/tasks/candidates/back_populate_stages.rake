namespace :candidates do
  desc "Back populates any old candidates that are not mapped to a stage based on their status property"
  task :back_populate_stages => :environment do 
    Candidate.find_each do |cand|
      if cand.potential? && !(cand.stage.present? && cand.stage.potential?)
        cand.stage = cand.organization.potential_stage
        cand.save
      elsif cand.bad_fit? && !(cand.stage.present? && cand.stage.bad_fit?) 
        cand.stage = cand.organization.bad_fit_stage
        cand.save
      elsif cand.qualified? && !(cand.stage.present? && cand.stage.qualified?) 
        cand.stage = cand.organization.qualified_stage
        cand.save
      end
    end
  end
end
