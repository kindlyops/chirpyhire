namespace :reports do
  desc 'Sends daily summary report'
  task daily: :environment do |_task|
    Reporter.new(Account, Report::Daily).report
  end
end
