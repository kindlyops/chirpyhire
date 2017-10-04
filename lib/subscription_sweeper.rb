class SubscriptionSweeper
  def self.call
    new.call
  end

  def call
    ended_trials.find_each(&:cancel)
    upcoming_billing.find_each(&method(:update_plan))
  end

  private

  def update_plan(subscription)
    BillingClerkJob.perform_later(subscription)
  end

  def upcoming_billing
    Subscription
      .where('current_period_end > ? AND current_period_end <= ?',
             tomorrow_start, tomorrow_end)
  end

  def ended_trials
    Subscription.trialing.where('trial_ends_at <= ?', DateTime.current)
  end

  def tomorrow_start
    DateTime.current.tomorrow.beginning_of_day.to_i
  end

  def tomorrow_end
    DateTime.current.tomorrow.end_of_day.to_i
  end
end
