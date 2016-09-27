namespace :activities do
  desc "Back populates any old candidate activites that are not mapped to a stage based on their status property"
  task :back_populate_stages => :environment do 
    Candidate.find_each do |candidate|
      BackPopulate::ActivityBackPopulator.populate(candidate)
    end
  end
end
