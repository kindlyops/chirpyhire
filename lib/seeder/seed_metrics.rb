class Seeder::SeedMetrics
  def self.call(account)
    new(account).call
  end

  def initialize(account)
    @account = account
  end

  def call
    organization.update(
      reached_contacts_count: reached_count,
      starred_contacts_count: starred_count
    )
  end

  attr_reader :account

  delegate :organization, to: :account

  def starred_count
    (ENV.fetch('DEMO_SEED_AMOUNT').to_i * 5 / 8).floor
  end

  def reached_count
    (ENV.fetch('DEMO_SEED_AMOUNT').to_i * 6 / 8).floor
  end
end
