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

      WAU Growth (WoW): #{growth}%
      WAU Total: #{count}
    MESSAGE
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV.fetch('SLACK_WEBHOOK'), channel: '#metric', username: 'freddy'
    )
  end

  def count
    @count ||= begin
      Account
        .where('current_sign_in_at >= ?', 1.week.ago)
        .where.not(id: excluded_ids)
        .count
    end
  end

  def excluded_ids
    @excluded_ids ||= begin
      Account.where(organization_id: [1, 2, 3, 5, 6, 7]).pluck(:id)
    end
  end

  def new_weekly_active_users_count
    @new_weekly_active_users_count ||= begin
      Account
        .where('current_sign_in_at >= ?', 1.week.ago)
        .where('created_at >= ?', 1.week.ago)
        .where.not(id: excluded_ids)
        .count
    end
  end

  def existing_weekly_active_users_count
    @existing_weekly_active_users_count ||= begin
      Account
        .where('current_sign_in_at >= ?', 1.week.ago)
        .where('created_at <= ?', 1.week.ago)
        .where.not(id: excluded_ids)
        .count
    end
  end

  def growth
    return '0' unless existing_weekly_active_users_count.positive?

    new_weekly_active_users_count.fdiv(existing_weekly_active_users_count) * 100
  end
end
