class DailyMailerPreview < ActionMailer::Preview
  def slipping_away
    DailyMailer.slipping_away(Account.first)
  end

  def newly_added
    DailyMailer.newly_added(Account.first)
  end

  def active
    DailyMailer.active(Account.first)
  end

  def passive
    DailyMailer.passive(Account.first)
  end

  def none
    DailyMailer.none(Account.first)
  end
end
