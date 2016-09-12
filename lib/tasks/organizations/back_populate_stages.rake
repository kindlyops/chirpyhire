namespace :organizations do
  desc "Back populates any old organizations that are not mapped to candidate stages to have defaults."
  task :back_populate_stages => :environment do 
    Organization.find_each do |org|
      unless org.stages.present? and org.stages.any?
        Stage.defaults(org.id).each do |stage|
          stage.save!
        end
      end
    end
  end
end
