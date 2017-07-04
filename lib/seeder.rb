class Seeder
  def seed
    account = Seeder::SeedAccount.call
    BotMaker::DefaultBot.call(account.organization)
    # Seeder::SeedContacts.call(account)
    Seeder::SeedMetrics.call(account)
  end
end
