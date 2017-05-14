class Internal::Metric::Wau
  def self.call
    new.call
  end

  def call
    notifier.ping message if Rails.env.production?
  end

  def message
    <<~MESSAGE
      Today, #{Date.current.strftime('%A, %b %d')}:

      #{count} weekly active #{users}!
    MESSAGE
  end

  def users
    'user'.pluralize(count)
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV.fetch('SLACK_WEBHOOK'), channel: '#metric', username: 'freddy'
    )
  end

  def count
    @count ||= Account.where('current_sign_in_at >= ?', 1.week.ago).count
  end
end
