class ReporterDailyJob < ApplicationJob
  def perform(account)
    Reporter::Daily.new(account).call
  end
end
