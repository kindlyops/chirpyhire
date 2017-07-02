class Seeder
  def seed
    account = Seeder::SeedAccount.call
    Seeder::SeedContacts.call(account)
    Seeder::SeedMetrics.call(account)
  end
end
