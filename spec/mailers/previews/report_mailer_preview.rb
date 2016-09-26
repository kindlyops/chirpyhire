class ReportMailerPreview < ActionMailer::Preview
  def daily
    Reporter.new(Account, Report::Daily, :daily).reports.first
  end

  def weekly
    Reporter.new(Account, Report::Weekly, :weekly).reports.first
  end
end
