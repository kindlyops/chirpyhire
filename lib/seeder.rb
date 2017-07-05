class Seeder
  def seed
    account = Seeder::SeedAccount.call
    bot = BotFactory::Maker.call(account.organization)
    create_bot_campaigns(account.organization, bot)
    Seeder::SeedContacts.call(account)
    Seeder::SeedMetrics.call(account)
  end

  private

  def create_bot_campaigns(organization, bot)
    organization.teams.find_each do |team|
      name = "#{bot.name} on call: #{team.name}"
      campaign = organization.campaigns.find_or_create_by(name: name)
      bot.bot_campaigns.create(inbox: team.inbox, campaign: campaign)
    end
  end
end
