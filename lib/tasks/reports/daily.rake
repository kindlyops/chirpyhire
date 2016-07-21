namespace :reports do
  desc "Sends daily summary report"
  task daily: :environment do |task|
    Reporter.new(Account, Report::Daily, :daily).report
  end
end
