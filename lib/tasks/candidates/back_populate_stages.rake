namespace :candidates do
  desc "Back populates any old candidates that are not mapped to a stage based on their status property"
  task :back_populate_stages => :environment do 
    Candidate.find_each do |cand|
      if cand.potential? && !(cand.stage.present? && cand.stage.potential?)
        cand.stage = Stage.find_by(organization_id: cand.organization.id, default_stage_mapping: Stage.default_stage_mapping[:potential])
        cand.save
      elsif cand.bad_fit? && !(cand.stage.present? && cand.stage.bad_fit?) 
        cand.stage = Stage.find_by(organization_id: cand.organization.id, default_stage_mapping: Stage.default_stage_mapping[:bad_fit])
        cand.save
      elsif cand.qualified? && !(cand.stage.present? && cand.stage.qualified?) 
        cand.stage = Stage.find_by(organization_id: cand.organization.id, default_stage_mapping: Stage.default_stage_mapping[:qualified])
        cand.save
      end
    end
  end
end
