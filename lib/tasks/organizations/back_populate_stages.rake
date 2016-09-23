namespace :organizations do
  desc "Back populates any old organizations that are not mapped to candidate stages to have defaults."
  task :back_populate_stages => :environment do 
    Organization.find_each do |org|
      unless org.stages.present?
        StageDefaults.populate(org)
        org.save!
      end
    end
  end
end
