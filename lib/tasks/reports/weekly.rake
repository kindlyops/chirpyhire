namespace :reports do
  desc "Sends weekly summary report"
  task weekly: :environment do |task|
    Reporter.new(Account, Report::Weekly, :weekly).report
  end
end
