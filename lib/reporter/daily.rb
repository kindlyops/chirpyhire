class Reporter::Daily
  WEEKEND = [0, 6].freeze

  def self.call
    return if WEEKEND.include?(Date.current.wday)

    Account.daily_email.find_each do |account|
      ReporterDailyJob.perform_later(account)
    end
  end

  def initialize(account)
    @account = account
  end

  attr_reader :account

  def call
    return unless contacts.exists?

    mailer.deliver_later
  end

  def mailer
    @mailer ||= fetch_mailer
  end

  def fetch_mailer
    segment = segments.select { |s| send("#{s}?") }.sample
    DailyMailer.send(segment, account) if segment.present?
  end

  def segments
    %i[slipping_away newly_added active passive]
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
