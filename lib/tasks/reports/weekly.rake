namespace :reports do
  desc "Sends weekly summary report"
  task weekly: :environment do |task|
    if Rails.env.production? && Date.current.monday?
      Reporter.new(Account, Report::Weekly, :weekly).report
    end
  end
end
