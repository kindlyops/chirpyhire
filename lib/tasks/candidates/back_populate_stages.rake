namespace :candidates do
  desc "Back populates any old candidates that are not mapped to a stage based on their status property"
  task :back_populate_stages => :environment do 
    Candidate.find_each do |cand|
      BackPopulate::CandidateStageRefresher.refresh(cand)
    end
  end
end
