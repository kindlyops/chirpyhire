namespace :reports do
  desc "Sends daily summary report"
  task daily: :environment do |task|
    DailyReporter.new(Account).report
  end
end
