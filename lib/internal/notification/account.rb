class Internal::Notification::Account
  def self.call(account)
    new(account).call
  end

  def initialize(account)
    @account = account
  end

  def call
    notifier.ping message if Rails.env.production?
  end

  private

  def message
    <<~MESSAGE
      #{account.email} just signed up for ChirpyHire!
    MESSAGE
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV.fetch('SLACK_WEBHOOK'), channel: '#metric', username: 'freddy'
    )
  end

  attr_reader :account
end
