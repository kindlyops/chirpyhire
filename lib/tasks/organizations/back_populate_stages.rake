namespace :organizations do
  desc "Back populates any old organizations that are not mapped to candidate stages to have defaults."
  task :back_populate_stages => :environment do 
    Organization.find_each do |organization|
      if StageDefaults.populate(organization)
        organization.save!
      end
    end
  end
end
