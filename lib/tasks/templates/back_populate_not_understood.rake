namespace :templates do
  desc "Back populates old surveys that don't have a not understood template"
  task :back_populate_not_understood => :environment do
    puts 'Updating organizations...' 
    Organization.find_each do |organization|
      unless organization.templates.map(&:name).include?('Not Understood')
        Registration::TemplatesCreator.new(organization).create_not_understood_template
      end
    end
  end
end
