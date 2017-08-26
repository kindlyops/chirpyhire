class Reporter::Daily
  WEEKEND = [0, 6].freeze

  def self.call
    return if WEEKEND.include?(Date.current.wday)

    Account.daily_email.find_each do |account|
      new(account).call
    end
  end

  def initialize(account)
    @account = account
  end

  attr_reader :account

  def call
    mailer.deliver_later
  end

  def mailer
    return DailyMailer.slipping_away(account) if slipping_away?
    return DailyMailer.newly_added(account) if newly_added?
    return DailyMailer.active(account) if active?
    return DailyMailer.passive(account) if passive?

    DailyMailer.none(account)
  end

  def passive?
    contacts.passive.exists?
  end

  def slipping_away?
    contacts.slipping_away.exists?
  end

  def newly_added?
    contacts.newly_added.exists?
  end

  def active?
    contacts.active.exists?
  end

  def contacts
    @contacts ||= Pundit.policy_scope(account, Contact)
  end
end
