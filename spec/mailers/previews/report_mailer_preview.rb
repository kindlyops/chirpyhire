class ReportMailerPreview < ActionMailer::Preview
  def daily
    Reporter.new(Account, Report::Daily).reports.first
  end

  def weekly
    Reporter.new(Account, Report::Weekly).reports.first
  end
end
