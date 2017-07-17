class SubscriptionSweeper
  def self.call
    new.call
  end

  def call
    ended_trials.find_each(&:cancel)
  end

  private

  def ended_trials
    Subscription.trialing.where('trial_ends_at <= ?', DateTime.current)
  end
end
